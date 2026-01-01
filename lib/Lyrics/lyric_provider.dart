
import 'dart:convert';

import 'package:boycott_subscription/Lyrics/id&lrc_convertor.dart';
import 'package:http/http.dart' as http;

Future<List<LyricLine>> fetchLyricsFromQuery(String query) async {
  try {
    // 1️⃣ Search track
    final searchUri = Uri.parse(
      'https://lyrics.paxsenix.org/spotify/search?q=${Uri.encodeComponent(query)}',
    );

    final searchResponse = await http.get(searchUri);
    if (searchResponse.statusCode != 200) return [];

    final List searchData = jsonDecode(searchResponse.body);
    if (searchData.isEmpty) return [];

    final String trackId = searchData.first['trackId'];

    // 2️⃣ Fetch lyrics
    final lyricsUri = Uri.parse(
      'https://lyrics.paxsenix.org/spotify/lyrics?id=$trackId',
    );

    final lyricsResponse = await http.get(lyricsUri);
    if (lyricsResponse.statusCode != 200) return [];

    final lrc = lyricsResponse.body
        .replaceAll('\\n', '\n') // ⭐ fix
        .trim();

    if (lrc.isEmpty) return [];

    // 3️⃣ Parse correctly
    return parseLRC(lrc);
  } catch (e) {
    print('Error: $e');
  }

  return [
    LyricLine(
    timestamp: Duration(minutes: 0, seconds: 2, milliseconds: 0),
    text: "No lyrics available",
  )
  ];
}

Future fetchLyricsFromQuery1(String query) async {
  try {
    // 1️⃣ Search track
    final searchUri = Uri.parse(
      'https://lyrics.paxsenix.org/spotify/search?q=${Uri.encodeComponent(query)}',
    );

    final searchResponse = await http.get(searchUri);
    if (searchResponse.statusCode != 200) return [];

    final List searchData = jsonDecode(searchResponse.body);
    if (searchData.isEmpty) return [];

    final String trackId = searchData.first['trackId'];

    // 2️⃣ Fetch lyrics
    final lyricsUri = Uri.parse(
      'https://lyrics.paxsenix.org/spotify/lyrics?id=$trackId',
    );

    final lyricsResponse = await http.get(lyricsUri);
    if (lyricsResponse.statusCode != 200) return [];

    final lrc = lyricsResponse.body
        .replaceAll('\\n', '\n') // ⭐ fix
        .trim();

    if (lrc.isEmpty) return [];

    // 3️⃣ Parse correctly
    return lrc;
  } catch (e) {
    print('Error: $e');
  }

  return [
    LyricLine(
    timestamp: Duration(minutes: 0, seconds: 2, milliseconds: 0),
    text: "No lyrics available",
  )
  ];
}



Future<List<LyricLine>?> fetchLyricLinesFromTitleArtist2(
  String title,
  String artist,
) async {
  // 1️⃣ Fetch Apple Music Track ID
  final trackId = await fetchTrackId(title, artist);
  print(trackId);
  if (trackId == null) {
    print('Apple Music track ID not found.');
    return null;
  }

  // 2️⃣ New Paxsenix Apple Music Lyrics API
  final url = Uri.parse(
    'https://lyrics.paxsenix.org/apple-music/lyrics?id=$trackId',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode != 200) {
      print('Failed to fetch lyrics: ${response.statusCode}');
      return null;
    }

    final data = jsonDecode(response.body);

    // 3️⃣ Use prebuilt line-timed LRC (BEST OPTION)
    final lrc = data['lrc'];
    if (lrc == null || lrc.toString().trim().isEmpty) {
      print('No LRC found in response.');
      return null;
    }
    // 4️⃣ Parse LRC into List<LyricLine>
    return parseLRC(lrc);
  } catch (e) {
    print('Error fetching lyrics: $e');
    return null;
  }
}




Future  fetchLyricLinesFromTitleArtist3(
  String title,
  String artist,
) async {
  // 1️⃣ Fetch Apple Music Track ID
  final trackId = await fetchTrackId(title, artist);
  if (trackId == null) {
    print('Apple Music track ID not found.');
    return null;
  }

  // 2️⃣ New Paxsenix Apple Music Lyrics API
  final url = Uri.parse(
    'https://lyrics.paxsenix.org/apple-music/lyrics?id=$trackId',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode != 200) {
      print('Failed to fetch lyrics: ${response.statusCode}');
      return null;
    }

    final data = jsonDecode(response.body);

    // 3️⃣ Use prebuilt line-timed LRC (BEST OPTION)
    final lrc = data['lrc'];
    if (lrc == null || lrc.toString().trim().isEmpty) {
      print('No LRC found in response.');
      return null;
    }
    // 4️⃣ Parse LRC into List<LyricLine>
    return lrc;
  } catch (e) {
    print('Error fetching lyrics: $e');
    return null;
  }
}
