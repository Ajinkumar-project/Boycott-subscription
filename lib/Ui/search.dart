import 'dart:convert';

import 'package:boycott_subscription/Models/song_model.dart';
import 'package:boycott_subscription/Ui/song_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class Search extends SearchDelegate{

  final AudioPlayer player;
  final Color colors;
  final Color color;

  Search({super.searchFieldLabel, super.searchFieldStyle, super.searchFieldDecorationTheme, super.keyboardType, super.textInputAction, super.autocorrect, super.enableSuggestions, required this.player, required this.colors, required this.color});
  @override
  String get searchFieldLabel => "Search Songs...";
  @override
  List<Widget>? buildActions(BuildContext context) {
    
    return [
      IconButton(onPressed: (){
      }, icon: Icon(Icons.clear),color: color,)
    ];
  }

 @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      scaffoldBackgroundColor: colors, // background
      appBarTheme:  AppBarTheme(
        backgroundColor: colors,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      inputDecorationTheme:  InputDecorationTheme(
        hintStyle: TextStyle(color: color),
        border: InputBorder.none,
      ),
      textTheme:  TextTheme(
        titleLarge: TextStyle(color: color),
      ),
    );
  }


  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, num);
    }, icon: Icon(Icons.arrow_back), color: color,);
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query .trim().isEmpty){
      return Center(
        child: Text("Type to search"),
      );
    }
    return buildSearchResult();
  }

  Widget buildSearchResult() {
    return FutureBuilder(
      future: searchSongsWithFullData(query),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error${snapshot.error}"));
        }
     print(snapshot.data!.length);

        return SongListView(playlistid: 'Search', playlistTitle: '', player: player, searchdata: snapshot.data!,);
      },
    );
  }
}


Future<List<String>> fetchSongIdsFromSearch(String query) async {
  final uri = Uri.parse(
   "https://www.jiosaavn.com/api.php?__call=autocomplete.get&_format=json&_marker=0&cc=in&includeMetaTags=1&query=$query",
  );

  final res = await http.get(uri);

  if (res.statusCode != 200) {
    throw Exception("Search API failed");
  }

  final Map<String, dynamic> data = jsonDecode(res.body);

  if (data['songs'] == null || data['songs']['data'] == null) {
    return [];
  }

  final List<dynamic> songs = data['songs']['data'];

  return songs
      .where((e) => e != null && e['id'] != null)
      .map<String>((e) => e['id'].toString())
      .toList();
}


Future<List<JioSaavnSong>> fetchFullSongDetails(List<String> ids) async {
  if (ids.isEmpty) return [];

  final uri = Uri.parse(
    "https://www.jiosaavn.com/api.php"
    "?__call=song.getDetails"
    "&_format=json"
    "&cc=in"
    "&_marker=0"
    "&pids=${ids.join(",")}",
  );

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception("Song details API failed");
  }

  final cleaned = response.body
      .replaceAll(RegExp(r'<!--|-->'), '')
      .trim();

  final Map<String, dynamic> jsonData = json.decode(cleaned);

  return jsonData.values
      .map((songJson) => JioSaavnSong.fromJson(songJson))
      .toList();
}

List <JioSaavnSong>searchSong = [];

Future<List<JioSaavnSong>> searchSongsWithFullData(String query) async {
  final ids = await fetchSongIdsFromSearch(query);
  return await fetchFullSongDetails(ids);
}
