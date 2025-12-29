import 'dart:convert';
import 'package:boycott_subscription/Models/playlist_model.dart';
import 'package:boycott_subscription/Models/song_model.dart';
import 'package:http/http.dart' as http;

class JioSaavnAPI {
  

  static Future<JiosaavnPlaylist> fetchPlaylist(String playlistcode) async {
    final baseUrl =
        "https://www.jiosaavn.com/api.php?__call=webapi.get&token=$playlistcode&type=playlist&includeMetaTags=0&_format=json&_marker=0";
    final url = baseUrl;

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Failed to load playlist");
    }

    // JioSaavn returns JSON with invalid chars before/after
    final cleaned = response.body
        .replaceFirst("<!--", "")
        .replaceFirst("-->", "")
        .trim();

    final jsonData = json.decode(cleaned);

    return JiosaavnPlaylist.fromJson(jsonData);
  }
}


class PlaylistSongAPI {
  static const baseUrl =
      "https://www.jiosaavn.com/api.php?__call=playlist.getDetails&_format=json&cc=in&_marker=0&listid=";

  /// Fetch playlist songs by playlist ID
  static Future<List<JioSaavnSong>> fetchSongs(String playlistId) async {
    final url = "$baseUrl$playlistId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Failed to load playlist songs");
    }

    // Clean any unexpected HTML comments or invalid chars
    final cleaned = response.body
        .replaceFirst("<!--", "")
        .replaceFirst("-->", "")
        .trim();

    final jsonData = json.decode(cleaned);

    final songsData = jsonData['songs'] as List<dynamic>?;

    if (songsData == null) return [];

    // Map JSON to Song objects (both encrypted + decrypted URL)
    return songsData
        .map((songJson) => JioSaavnSong.fromJson(songJson))
        .toList();
  }
}
void joisong() async {
  
  // final songs = await PlaylistSongAPI.fetchSongs(playlist.id);
  // final playlist = await JioSaavnAPI.fetchPlaylist();
  // print("Playlist: ${playlist.title}");
  // print("Songs: ${playlist.songcount}");
  // print("Image:${playlist.image}");
  // print("PlayId:${playlist.id}");
  // Dq3pWn1coqesud-ETNX4vg__
  // for (var song in songs) {
  //   print("Title: ${song.title}");
  //   print("Encrypted URL: ${song.encryptedMediaUrl}");
  //   print("Decrypted URL: ${song.decryptedMediaUrl}");
  //   print("----------------------------");
  // }
}
