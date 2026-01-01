// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:boycott_subscription/Bloc/bloc_model.dart';
import 'package:boycott_subscription/Lyrics/id&lrc_convertor.dart';
import 'package:boycott_subscription/Lyrics/lyric_model.dart';
import 'package:boycott_subscription/Models/song_model.dart';
import 'package:boycott_subscription/Song_Data/playingSong.dart';
import 'package:boycott_subscription/Ui/lyric_page.dart';
import 'package:boycott_subscription/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:just_audio/just_audio.dart';

class PlayerPage extends StatefulWidget {
  PlayerPage({super.key, required this.songdata, required this.player});
  final List<JioSaavnSong> songdata;
  final AudioPlayer player;
  final unescape = HtmlUnescape();

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String to500(String url) {
      return url.replaceAll(RegExp(r'\d+x\d+'), '500x500');
    }

    

    String formatTime(Duration d) {
      final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final second = d.inSeconds.remainder(60).toString().padLeft(2, '0');

      return "$minutes:$second";
    }

    // ignore: no_leading_underscores_for_local_identifiers
    Timer? _indexTimer;
    // ignore: no_leading_underscores_for_local_identifiers
    int? _lastIndex;

    Future<int> stableInt(
      int index, {
      Duration delay = const Duration(seconds: 1),
    }) async {
      _lastIndex = index;

      _indexTimer?.cancel();

      final completer = Completer<int>();

      _indexTimer = Timer(delay, () {
        completer.complete(_lastIndex!);
      });

      return completer.future;
    }

    return BlocBuilder<ActiveColor,int>(
      builder: (context, activeColor) {
        return BlocBuilder<Apptheam , bool>(
          builder: (context , isdark) {
            return Scaffold(
              backgroundColor: isdark ? bgcolor:Colors.white,
              appBar: AppBar(
                backgroundColor: isdark ? bgcolor:Colors.white,
                centerTitle: true,
                title: Text(
                  "Now Playing",
                  style: TextStyle(
                    color: Color(activeColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              body: BlocListener<PlayIndex, int>(
                listener: (context, state) async {
                  context.read<Lyrices>().empty();
                  final stableIndex = await stableInt(state);
                  context.read<Lyrices>().setLyrics(
                    widget.unescape.convert(nowplayingdata[stableIndex].title),
                    nowplayingdata[stableIndex].primaryArtists,
                    nowplayingdata[stableIndex].primaryArtists.length >= 15
                        ? nowplayingdata[stableIndex].language
                        : nowplayingdata[stableIndex].primaryArtists,
                  );
                  // context.read<SongDownloads>().checkIfDownloaded(
                  //   widget.unescape.convert(nowplayingdata[stableIndex].title),
                  // );
                },
                child: BlocBuilder<PlayIndex, int>(
                  builder: (context, playindex) {
                    context.read<PlayIndex>().current(widget.player);
                     context.read<SongDownloads>().
                     checkIfDownloaded(
                    widget.unescape.convert(nowplayingdata[playindex].title),
                  );
                    context.read<Seeker>().isfav(nowplayingdata[playindex].id);
                    return Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(8),
                              child: Image.network(
                                height: 350,
                                width: 350,
                                to500(widget.songdata[playindex].image),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: AlignmentGeometry.topLeft,
                                  child: Text(
                                    widget.unescape.convert(
                                      widget.songdata[playindex].title,
                                    ),
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Color(activeColor),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: AlignmentGeometry.topLeft,
                                  child: Text(
                                    widget.songdata[playindex].primaryArtists,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Color(activeColor),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  child: BlocBuilder<Lyrices, List<LyricLine>>(
                                    builder: (context, lyrx) {
                                      return BlocBuilder<Position, Duration>(
                                        builder: (context, position) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LyricPage(color: Color(activeColor), player: widget.player,),
                                                ),
                                              );
                                            },
                                            child: CenterLyricsView(
                                              color: Color(activeColor),
                                              lyrics: lyrx,
                                              position: position,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                BlocBuilder<Position, Duration>(
                                  builder: (context, position) {
                                    return BlocBuilder<SongDuration, Duration>(
                                      builder: (context, duration) {
                                        return Row(
                                          children: [
                                            Text(formatTime(position),
                                    style: TextStyle(
                                      color: isdark? Color(activeColor):null,
                                    )),
                                            Expanded(
                                              child: Slider(
                                                thumbColor: Colors.transparent,
                                                inactiveColor: isdark? Colors.white38: null,
                                                activeColor: Color(activeColor),
                                                min: 0,
                                                max: duration.inSeconds.toDouble(),
                                                value: position.inSeconds.toDouble(),
                                                onChanged: (value) {
                                                  widget.player.seek(
                                                    Duration(seconds: value.toInt()),
                                                  );
                                                },
                                              ),
                                            ),
                                            Text(formatTime(duration) ,
                                    style: TextStyle(
                                      color: isdark? Color(activeColor):null,
                                    )),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                BlocBuilder<Isplaying, bool>(
                                  builder: (context, isplaying) {
                                    return BlocBuilder<Seeker, bool>(
                                      builder: (context, stat) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if (stat) {
                                                  removeFromFavorite(
                                                    nowplayingdata[playindex].id,
                                                  );
                                                  context.read<Seeker>().isfav(
                                                    nowplayingdata[playindex].id,
                                                  );
                                                } else {
                                                  addfavorite(
                                                    nowplayingdata[playindex],
                                                  );
                                                  context.read<Seeker>().isfav(
                                                    nowplayingdata[playindex].id,
                                                  );
                                                }
                                                print(nowplayingdata[playindex].decryptedMediaUrl320kbps);
                                              },
                                              icon: stat
                                                  ? Icon(Icons.favorite)
                                                  : Icon(Icons.favorite_border),
                                              iconSize: 30,
                                              color: Color(activeColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                widget.player.seekToPrevious();
                                                context.read<Lyrices>().empty();
                                                context.read<PlayIndex>().current(
                                                  widget.player,
                                                );
                                              },
                                              icon: Icon(Icons.skip_previous_rounded),
                                              iconSize: 50,
                                              color: Color(activeColor),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (widget.player.playing == true) {
                                                  widget.player.pause();
                                                } else {
                                                  widget.player.play();
                                                }
                                              },
                                              icon: StreamBuilder(
                                                stream: widget.player.playingStream,
                                                builder: (context, asyncSnapshot) {
                                                  return Icon(
                                                    asyncSnapshot.data ?? false
                                                        ? Icons.pause
                                                        : Icons.play_arrow_rounded,
                                                  );
                                                },
                                              ),
                                              iconSize: 60,
                                              color: Color(activeColor),
                                            ),
                                            IconButton(
                                              onPressed: ()async {
                                                
                                                widget.player.seekToNext();
                                                context.read<Lyrices>().empty();
                                                context.read<PlayIndex>().current(
                                                  widget.player,
                                                );
                                              },
                                              icon: Icon(Icons.skip_next_rounded),
                                              iconSize: 50,
                                              color: Color(activeColor),
                                            ),
                                            BlocBuilder<
                                              SongDownloads,
                                              SongDownloadStatus
                                            >(
                                              builder: (context, state) {
                                                switch (state.status) {
                                                  case DownloadState.downloaded:
                                                    return Icon(
                                                      Icons.download_done_rounded,
                                                      size: 30,
                                              color: Color(activeColor),
                                                    );
                                                  case DownloadState.downloading:
                                                    return SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  case DownloadState.failed:
                                                    return IconButton(
                                                      onPressed: () {
                                                        context.read<SongDownloads>().downloadSong(
                                                          nowplayingdata[playindex]
                                                              .decryptedMediaUrl320kbps,
                                                          audioUrl:
                                                              nowplayingdata[playindex]
                                                                  .decryptedMediaUrl320kbps,
                                                          title: widget.unescape.convert(
                                                            nowplayingdata[playindex]
                                                                .title,
                                                          ),
                                                          primaryArtist: widget.unescape
                                                              .convert(
                                                                nowplayingdata[playindex]
                                                                    .primaryArtists,
                                                              ),
                                                          album: widget.unescape.convert(
                                                            nowplayingdata[playindex]
                                                                .album,
                                                          ),
                                                          featuredArtist: widget
                                                              .unescape
                                                              .convert(
                                                                nowplayingdata[playindex]
                                                                    .featuredArtists,
                                                              ),
                                                          language: widget.unescape
                                                              .convert(
                                                                nowplayingdata[playindex]
                                                                    .language,
                                                              ),
                                                          year: widget.unescape.convert(
                                                            nowplayingdata[playindex]
                                                                .year,
                                                          ),
                                                          imageUrl: to500(
                                                            widget
                                                                .songdata[playindex]
                                                                .image,
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(Icons.refresh_rounded),
                                              iconSize: 30,
                                              color: Color(activeColor),
                                                    );
                                                  case DownloadState.notDownloaded:
                                                    return IconButton(
                                                      onPressed: () {
                                                        context.read<SongDownloads>().downloadSong(
                                                          nowplayingdata[playindex]
                                                              .decryptedMediaUrl320kbps,
                                                          audioUrl:
                                                              nowplayingdata[playindex]
                                                                  .decryptedMediaUrl320kbps,
                                                          title: widget.unescape.convert(
                                                            nowplayingdata[playindex]
                                                                .title,
                                                          ),
                                                          primaryArtist: widget.unescape
                                                              .convert(
                                                                nowplayingdata[playindex]
                                                                    .primaryArtists,
                                                              ),
                                                          album: widget.unescape.convert(
                                                            nowplayingdata[playindex]
                                                                .album,
                                                          ),
                                                          featuredArtist: widget
                                                              .unescape
                                                              .convert(
                                                                nowplayingdata[playindex]
                                                                    .featuredArtists,
                                                              ),
                                                          language: widget.unescape
                                                              .convert(
                                                                nowplayingdata[playindex]
                                                                    .language,
                                                              ),
                                                          year: widget.unescape.convert(
                                                            nowplayingdata[playindex]
                                                                .year,
                                                          ),
                                                          imageUrl: to500(
                                                            widget
                                                                .songdata[playindex]
                                                                .image,
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(Icons.download),
                                              iconSize: 30,
                                              color: Color(activeColor),
                                                    );
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }
        );
      }
    );
  }
}