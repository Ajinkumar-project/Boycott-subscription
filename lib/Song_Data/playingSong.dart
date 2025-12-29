
import 'package:boycott_subscription/Models/song_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

List <JioSaavnSong> nowplayingdata = [];
List <JioSaavnSong> favoriteSongs = [];


void loadFavoriteSongs() {
  final box = Hive.box('favorite');

  // Step 1: Convert raw Hive maps to List<Map<String, dynamic>>
  final List<Map<String, dynamic>> rawSongs = box.values
      .map((data) => Map<String, dynamic>.from(data as Map))
      .toList();

  // Step 2: Sort by 'addedAt'
  rawSongs.sort((a, b) => b["addedAt"].compareTo(a["addedAt"]));

  // Step 3: Convert to List<JioSaavnSong>
  favoriteSongs = rawSongs
      .map((json) => JioSaavnSong.fromJson(json))
      .toList();
}





void addfavorite(JioSaavnSong song) {
  final box = Hive.box("favorite");

  final map = Map<String, dynamic>.from(song.toJson());
  map["addedAt"] = DateTime.now().millisecondsSinceEpoch;

  box.put(song.id, map);
  loadFavoriteSongs();
}



void removeFromFavorite(String songId) {
  final box = Hive.box('favorite');

  if (box.containsKey(songId)) {
    box.delete(songId); 
  }

  loadFavoriteSongs(); 
}

