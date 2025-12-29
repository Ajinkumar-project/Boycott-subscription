import 'package:boycott_subscription/Song_Decoder/decoder.dart';

class JioSaavnSong {
  final String id;
  final String title;
  final String album;
  final String year;
  final String music;
  final String musicId;
  final String primaryArtists;
  final String primaryArtistsId;
  final String featuredArtists;
  final String featuredArtistsId;
  final String singers;
  final String starring;
  final String image;
  final String label;
  final String albumId;
  final String language;
  final String origin;
  final String playCount;
  final int isDrm;
  final String copyrightText;
  final bool kbps320;
  final bool isDolbyContent;
  final int explicitContent;
  final bool hasLyrics;
  final String lyricsSnippet;
  final String encryptedDrmMediaUrl;
  final String encryptedMediaUrl;
  final String encryptedMediaPath;
  final String mediaPreviewUrl;
  final String permaUrl;
  final String albumUrl;
  final String duration;
  final Map<String, dynamic> rights;
  final bool webp;
  final String cacheState;
  final String starred;
  final Map<String, String> artistMap;
  final String releaseDate;
  final String vcode;
  final String vlink;
  final bool trillerAvailable;
  final String labelUrl;
  final String labelId;
  final String decryptedMediaUrl;
  final String decryptedMediaUrl320kbps;

  JioSaavnSong({
    required this.id,
    required this.title,
    required this.album,
    required this.year,
    required this.music,
    required this.musicId,
    required this.primaryArtists,
    required this.primaryArtistsId,
    required this.featuredArtists,
    required this.featuredArtistsId,
    required this.singers,
    required this.starring,
    required this.image,
    required this.label,
    required this.albumId,
    required this.language,
    required this.origin,
    required this.playCount,
    required this.isDrm,
    required this.copyrightText,
    required this.kbps320,
    required this.isDolbyContent,
    required this.explicitContent,
    required this.hasLyrics,
    required this.lyricsSnippet,
    required this.encryptedDrmMediaUrl,
    required this.encryptedMediaUrl,
    required this.encryptedMediaPath,
    required this.mediaPreviewUrl,
    required this.permaUrl,
    required this.albumUrl,
    required this.duration,
    required this.rights,
    required this.webp,
    required this.cacheState,
    required this.starred,
    required this.artistMap,
    required this.releaseDate,
    required this.vcode,
    required this.vlink,
    required this.trillerAvailable,
    required this.labelUrl,
    required this.labelId, 
    required this.decryptedMediaUrl, 
    required this.decryptedMediaUrl320kbps,
  });

  factory JioSaavnSong.fromJson(Map<String, dynamic> json) {
    final encryptedUrl = json['encrypted_media_url'] ?? '';
    final decryptedUrl = createDownloadLinks(encryptedUrl)
      ?.firstWhere((link) => link.quality == '96kbps')
      .link ?? '';
      final decryptedUrl360kbps = createDownloadLinksMaxQuality(encryptedUrl)
      .firstWhere((link) => link.quality == '320kbps')
      .link;
    return JioSaavnSong(
      id: json["id"] ?? "",
      title: json["song"] ?? "",
      album: json["album"] ?? "",
      year: json["year"] ?? "",
      music: json["music"] ?? "",
      musicId: json["music_id"] ?? "",
      primaryArtists: json["primary_artists"] ?? "",
      primaryArtistsId: json["primary_artists_id"] ?? "",
      featuredArtists: json["featured_artists"] ?? "",
      featuredArtistsId: json["featured_artists_id"] ?? "",
      singers: json["singers"] ?? "",
      starring: json["starring"] ?? "",
      image: json["image"] ?? "",
      label: json["label"] ?? "",
      albumId: json["albumid"] ?? "",
      language: json["language"] ?? "",
      origin: json["origin"] ?? "",
      playCount: json["play_count"].toString() ,
      isDrm: json["is_drm"] ?? 0,
      copyrightText: json["copyright_text"] ?? "",
      kbps320: json["320kbps"] == "true",
      isDolbyContent: json["is_dolby_content"] ?? false,
      explicitContent: json["explicit_content"] ?? 0,
      hasLyrics: json["has_lyrics"] == "true" || json["has_lyrics"] == true,
      lyricsSnippet: json["lyrics_snippet"] ?? "",
      encryptedDrmMediaUrl: json["encrypted_drm_media_url"] ?? "",
      encryptedMediaUrl: json["encrypted_media_url"] ?? "",
      encryptedMediaPath: json["encrypted_media_path"] ?? "",
      mediaPreviewUrl: json["media_preview_url"] ?? "",
      permaUrl: json["perma_url"] ?? "",
      albumUrl: json["album_url"] ?? "",
      duration: json["duration"] ?? "",
      rights: Map<String, String>.from(json["artistMap"] ?? {}),
      webp: json["webp"] ?? false,
      cacheState: json["cache_state"] ?? "",
      starred: json["starred"] ?? "",
      artistMap: Map<String, String>.from(json["artistMap"] ?? {}),
      releaseDate: json["release_date"] ?? "",
      vcode: json["vcode"] ?? "",
      vlink: json["vlink"] ?? "",
      trillerAvailable: json["triller_available"] ?? false,
      labelUrl: json["label_url"] ?? "",
      labelId: json["label_id"] ?? "", 
      decryptedMediaUrl: decryptedUrl,
       decryptedMediaUrl320kbps: decryptedUrl360kbps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "song": title,
      "album": album,
      "year": year,
      "music": music,
      "music_id": musicId,
      "primary_artists": primaryArtists,
      "primary_artists_id": primaryArtistsId,
      "featured_artists": featuredArtists,
      "featured_artists_id": featuredArtistsId,
      "singers": singers,
      "starring": starring,
      "image": image,
      "label": label,
      "albumid": albumId,
      "language": language,
      "origin": origin,
      "play_count": playCount,
      "is_drm": isDrm,
      "copyright_text": copyrightText,
      "320kbps": kbps320,
      "is_dolby_content": isDolbyContent,
      "explicit_content": explicitContent,
      "has_lyrics": hasLyrics,
      "lyrics_snippet": lyricsSnippet,
      "encrypted_drm_media_url": encryptedDrmMediaUrl,
      "encrypted_media_url": encryptedMediaUrl,
      "encrypted_media_path": encryptedMediaPath,
      "media_preview_url": mediaPreviewUrl,
      "perma_url": permaUrl,
      "album_url": albumUrl,
      "duration": duration,
      "rights": rights,
      "webp": webp,
      "cache_state": cacheState,
      "starred": starred,
      "artistMap": artistMap,
      "release_date": releaseDate,
      "vcode": vcode,
      "vlink": vlink,
      "triller_available": trillerAvailable,
      "label_url": labelUrl,
      "label_id": labelId,
    };
  }
}
