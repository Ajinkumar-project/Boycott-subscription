import 'dart:io';

import 'package:boycott_subscription/Downloads/song_pipeline_service.dart';
import 'package:boycott_subscription/Lyrics/lix.dart';
import 'package:boycott_subscription/Lyrics/lyric_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';

class PlayIndex extends Cubit<int>{
  PlayIndex():super(-1);
    void playindex(int playIndex){
        emit(playIndex);
    }
    void current (AudioPlayer player ,){
    player.currentIndexStream.listen((p){
      if(p != null ){
        emit(p);
      }
    });
  }
    
}
class Isplaying extends Cubit<bool>{
  Isplaying():super(false);
  void isplaying(bool status){
    emit(status);
  }
}

class Continueplaying extends Cubit<bool>{
  Continueplaying():super(false);
  void continueplayingStatus(bool status){
    emit(status);
  }
}
class Seeker extends Cubit<bool>{
  Seeker():super(false);
  void isfav(String songid ){
  final box = Hive.box("favorite");
    bool stst =  box.containsKey(songid);
    emit(stst);
}
}


class Position extends Cubit<Duration>{
  Position():super(Duration.zero);
  void position (AudioPlayer player ){
    player.positionStream.listen((p){
      emit( p);
    });
  }
}
class SongDuration extends Cubit<Duration>{
  SongDuration():super(Duration.zero);
  void duration  (AudioPlayer player){
     player.durationStream.listen((d){
      emit(d ?? Duration.zero);
    });
  }
}


class Lyrices extends Cubit<List<LyricLine>> {
  Lyrices() : super([
    LyricLine(
    timestamp: Duration(minutes: 0, seconds: 2, milliseconds: 0),
    text: "Loading Lyrics...",
  )
  ]);
  void setLyrics(String title, String album , music) async {
    final lyx =await fetchLyricsFromQuery(title);
    final lyx1 = await fetchLyricLinesFromTitleArtist2(title , music);
    emit(lyx1 ?? lyx );
  }
  void empty (){
    emit([LyricLine(
    timestamp: Duration(minutes: 0, seconds: 2, milliseconds: 0),
    text: "Loading Lyrics...",
  )
    ]);
  }
}


enum DownloadState{
  notDownloaded,
  downloading,
  downloaded,
  failed
}


class SongDownloadStatus{
  final DownloadState status;

  const SongDownloadStatus({required this.status,});

  factory SongDownloadStatus.initial(){
    return  SongDownloadStatus(status: DownloadState.notDownloaded,);
  }
}
class SongDownloads extends Cubit<SongDownloadStatus> {
  final SongPipelineService service;

  SongDownloads(this.service)
      : super(SongDownloadStatus.initial());

  /// Check if song already exists
  Future<void> checkIfDownloaded(String title) async {
      final dir = Directory('/storage/emulated/0/Download');
      final direxists = dir.listSync().any(
      (e) => e.path.endsWith('Boycott Music'),
    );
    if(direxists == true){
        final musicDir = Directory('/storage/emulated/0/Download/Boycott Music');
    final exists = musicDir.listSync().any(
      (e) => e.path.endsWith('$title.m4a'),
    );
    if(exists == true){
      emit(SongDownloadStatus(status: DownloadState.downloaded));
    }else{
      emit(SongDownloadStatus(status: DownloadState.notDownloaded));
    }
  }else {
    return ; 
  }
    }


    

  /// Download audio + metadata + lyrics
  Future<void> downloadSong(String decryptedMediaUrl, {
    required String audioUrl,
    required String title,
    required String primaryArtist,
    required String album,
    required String featuredArtist,
    required String language,
    required String year,
    required String imageUrl,
  }) async {
    try {
      emit(
        const SongDownloadStatus(
          status: DownloadState.downloading,
        ),
      );

      // 1️⃣ Audio + metadata
      await service.processSong(
        audioUrl: audioUrl,
        filename: title,
        title: title,
        artist: primaryArtist,
        album: album,
        albumArtist: featuredArtist,
        genre: language,
        year: parseYear(year),
        artworkUrl: imageUrl,
      );

      // 2️⃣ Lyrics
      
      


      Future fetchlrc ()async{
        final lrc = await fetchLyricLinesFromTitleArtist3(
        title,
        primaryArtist.length >= 15 ? language : primaryArtist,
      );
      if (lrc.toString() == "null"){
        final lyx =await fetchLyricsFromQuery1(title);
        return lyx;
      }
      return lrc;
      }
      final lrc = await fetchlrc();

      

      await service.writeLrcToTemp(
        title: title,
        lrcContent: lrc.toString(),
      );

      emit(
        const SongDownloadStatus(
          status: DownloadState.downloaded,
        ),
      );
    } catch (e) {
      emit(
        const SongDownloadStatus(
          status: DownloadState.failed,
        ),
      );
    }
  }
}



class Apptheam extends Cubit<bool>{

final Box box = Hive.box('settings');

  Apptheam()
      : super(Hive.box('settings').get('darkMode', defaultValue: false));

  void darkmode(bool value) {
    box.put('darkMode', value);
    emit(value);
  }
}

class ActiveColor extends Cubit<int>{
  final Box box = Hive.box('settings');
  ActiveColor():super(Hive.box('settings').get('color1', defaultValue: Colors.pinkAccent.toARGB32()));
  void activeColor ( int color ){
    box.put('color1', color);
    emit(color);
  }
}