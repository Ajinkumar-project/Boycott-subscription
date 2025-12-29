
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart';


class SongPipelineService {
final Dio _dio = Dio();
final MediaStore _mediaStore = MediaStore();
Future<String> downloadToTemp(String url, String filename) async {
  final tempDir = await getTemporaryDirectory();
  final path = '${tempDir.path}/$filename.m4a';

  await _dio.download(
    url,
    path,
    options: Options(
      followRedirects: true,
      receiveTimeout: const Duration(minutes: 5),
      sendTimeout: const Duration(minutes: 5),
    ),
  );

  return path;
}



Future<Picture?> fetchArtworkBytes(String? imageurl)async{
  if(imageurl == null || imageurl.isEmpty){
return null;
  }else{
  
  final responce =await _dio.get(
    imageurl,
    options: Options(responseType: ResponseType.bytes),
    );
    return Picture(
      mimeType: 'image/png', 
      data: Uint8List.fromList(responce.data),
      );
  } 
}


Future<void> tagfile(
  {required String title,
  required String artist,
  required String album,
  required String albumartist,
  required String filePath,
  required String genre,
  int? track,
  int? totaltrack,
  required Picture? artworkBytes,
   int? year
  }
) async {
  final metadata = Metadata(
    title: title,
    artist: artist,
    album: album,
    albumArtist: albumartist,
    genre: genre,
    trackNumber: track,
    trackTotal: totaltrack,
    picture: artworkBytes,
    year: year
    
  );
  await MetadataGod.writeMetadata(file: filePath, metadata: metadata);
}
Future<String> saveToDownloads(String filePath) async {
  final uri = await _mediaStore.saveFile(
    tempFilePath: filePath,
    dirType: DirType.download,
    dirName: DirName.download, // optional subfolder
  );

  return uri.toString() ;
}
Future<String> writeLrcToTemp({
  required String title,
  required String lrcContent,
}) async {
  final tempDir = await getTemporaryDirectory();

  final lrcPath = '${tempDir.path}/$title.lrc';

  final file = File(lrcPath);
  await file.writeAsString(
    lrcContent,
    flush: true,
  );
  debugPrint('LRC path: $lrcPath');
debugPrint('LRC size: ${await File(lrcPath).length()}');


  return saveLrcToMusicFolder(lrcPath);
}
Future<String> saveLrcToMusicFolder(String tempLrcPath) async {
  final uri = await _mediaStore.saveFile(
    tempFilePath: tempLrcPath,
    dirType: DirType.download,
    dirName: DirName.download,
    relativePath: 'Boycott Music'
  );
  

  return uri.toString() ;
}



Future<String> processSong({
  required String audioUrl,
  required String filename,
  required String title,
  required String artist,
  required String album,
  required String albumArtist,
  required String genre,
   int? year,
    int? track,
    int? totalTrack,
  required String artworkUrl,
  }) async {
    final tempPath = await downloadToTemp(audioUrl, filename);

    print(tempPath);
    final artwork = await fetchArtworkBytes(artworkUrl);
    await tagfile(
      title: title,
      artist: artist,
      album: album,
      albumartist: albumArtist,
      filePath: tempPath,
      genre: genre,
      artworkBytes: artwork ,
      year:year ,
    );
    return await saveToDownloads(tempPath);
  }
}
int? parseYear(String? year) {
  if (year == null || year.isEmpty) return null;

  final match = RegExp(r'\d{4}').firstMatch(year);
  if (match == null) return null;

  return int.tryParse(match.group(0)!);
}
