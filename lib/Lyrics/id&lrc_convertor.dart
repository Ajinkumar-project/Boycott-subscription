// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

/// Step 1: Optional iTunes search to get metadata
Future<int?> fetchTrackId(String title, String artist) async {
  final query = Uri.encodeComponent('$title $artist');
  final url = Uri.parse(
      'https://itunes.apple.com/search?term=$query&entity=song&limit=1');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['resultCount'] != null && json['resultCount'] > 0) {
        final first = json['results'][0];
        if (first['trackId'] != null) {
          return first['trackId'];
        }
      }
      print('No results found for "$title" by "$artist".');
      return null;
    } else {
      print('iTunes search failed (${response.statusCode})');
      return null;
    }
  } catch (e) {
    print('Error searching iTunes: $e');
    return null;
  }
}


class LyricLine {
  final Duration timestamp;
  final String text;

  LyricLine({required this.timestamp, required this.text});
}


List<LyricLine> parseLRC(String lrc) {
  final lines = lrc.split('\n');
  List<LyricLine> result = [];

  for (var line in lines) {
    line = line.trim();
    if (line.isEmpty) continue;

    // Match [mm:ss.xx] or [mm:ss.xxx]
    final match = RegExp(r'\[(\d{2}):(\d{2})\.(\d{2,3})\](.*)').firstMatch(line);
    if (match != null) {
      final minutes = int.parse(match.group(1)!);
      final seconds = int.parse(match.group(2)!);
      final millisPart = match.group(3)!;
      int milliseconds;

      // Convert 2 or 3 digit fractions to milliseconds
      if (millisPart.length == 2) {
        milliseconds = int.parse(millisPart) * 10;
      } else {
        milliseconds = int.parse(millisPart);
      }

      final text = match.group(4)!.trim();

      result.add(LyricLine(
        timestamp: Duration(
            minutes: minutes, seconds: seconds, milliseconds: milliseconds),
        text: text,
      ));
    }
  }

  return result;
}
