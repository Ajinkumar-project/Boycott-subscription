import 'package:boycott_subscription/Bloc/bloc_model.dart';
import 'package:boycott_subscription/Lyrics/id&lrc_convertor.dart';
import 'package:boycott_subscription/Song_Data/playingSong.dart';
import 'package:boycott_subscription/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:just_audio/just_audio.dart';

class Fulllyx extends StatefulWidget {
  final List<LyricLine> lyrics;
  final Duration position;
  final Color activeColor;
  final AudioPlayer player;
  const Fulllyx({
    super.key,
    required this.lyrics,
    required this.position,
    required this.activeColor,
    required this.player,
  });

  @override
  State<Fulllyx> createState() => _FulllyxState();
}

class _FulllyxState extends State<Fulllyx> {
  final ScrollController _scrollController = ScrollController();
  static const double _lineHeight = 100;
  int _activeIndex = 0;
  bool _userScrolling = false;
  int _getActiveIndex(Duration position) {
    for (int i = 0; i < widget.lyrics.length - 1; i++) {
      if (position >= widget.lyrics[i].timestamp &&
          position < widget.lyrics[i + 1].timestamp) {
        return i;
      }
    }
    return widget.lyrics.length - 1;
  }

  void _scrollToActive() {
    if (!_scrollController.hasClients || _userScrolling) return;
    final targetOffset = _activeIndex * _lineHeight;
    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didUpdateWidget(covariant Fulllyx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lyrics.isEmpty) return;
    final newIndex = _getActiveIndex(widget.position);
    if (newIndex != _activeIndex) {
      _activeIndex = newIndex;
      _scrollToActive();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();

    String formatTime(Duration d) {
      final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final second = d.inSeconds.remainder(60).toString().padLeft(2, '0');

      return "$minutes:$second";
    }

    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction != ScrollDirection.idle) {
          _userScrolling = true;
        } else {
          Future.delayed(Duration(milliseconds: 900), () {
            _userScrolling = false;
          });
        }
        return false;
      },
      child: BlocBuilder<Apptheam, bool>(
        builder: (context, isdark) {
          return BlocBuilder<PlayIndex, int>(
            builder: (context, currint) {
              return Scaffold(
                backgroundColor: isdark ? bgcolor : Colors.white,
                body: Column(
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      flex: 2 * 10,
                      child: Center(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back),
                              color: widget.activeColor,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.only(right: 10),
                                  child: Material(
                                    elevation: 5,
                                    shadowColor: isdark ? widget.activeColor : Colors.black54,
                                    child: ClipRRect(
                                      borderRadius: BorderRadiusGeometry.circular(
                                        8,
                                      ),
                                      child: Image.network(
                                        nowplayingdata[currint].image,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    unescape.convert(
                                      nowplayingdata[currint].title,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: widget.activeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    unescape.convert(
                                      nowplayingdata[currint].primaryArtists,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: widget.activeColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8 * 10,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: widget.lyrics.length,
                        itemBuilder: (context, index) {
                          final isActive = index == _activeIndex;
                          return GestureDetector(
                            onTap: () {
                              widget.player.seek(
                                widget.lyrics[index].timestamp,
                              );
                            },
                            child: SizedBox(
                              height: _lineHeight,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    curve: Curves.fastOutSlowIn,
                                    duration: Duration(milliseconds: 500),
                                    style: TextStyle(
                                      fontSize: isActive ? 25 : 25,
                                      color: isActive
                                          ? widget.activeColor
                                          : Colors.grey.shade500,
                                      fontWeight: isActive
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    child: Text(
                                      widget.lyrics[index].text,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2 * 10,
                      child: Column(
                        children: [
                          BlocBuilder<Position, Duration>(
                            builder: (context, position) {
                              return BlocBuilder<SongDuration, Duration>(
                                builder: (context, duration) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          formatTime(position),
                                          style: TextStyle(
                                            color: isdark
                                                ? widget.activeColor
                                                : null,
                                          ),
                                        ),
                                        Expanded(
                                          child: Slider(
                                            thumbColor: Colors.transparent,
                                            inactiveColor: isdark
                                                ? Colors.white38
                                                : null,
                                            activeColor: widget.activeColor,
                                            min: 0,
                                            max: duration.inSeconds.toDouble(),
                                            value: position.inSeconds
                                                .toDouble(),
                                            onChanged: (value) {
                                              widget.player.seek(
                                                Duration(
                                                  seconds: value.toInt(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Text(
                                          formatTime(duration),
                                          style: TextStyle(
                                            color: isdark
                                                ? widget.activeColor
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                color: widget.activeColor,
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
                                color: widget.activeColor,
                              ),
                              IconButton(
                                onPressed: () async {
                                  widget.player.seekToNext();
                                  context.read<Lyrices>().empty();
                                  context.read<PlayIndex>().current(
                                    widget.player,
                                  );
                                },
                                icon: Icon(Icons.skip_next_rounded),
                                iconSize: 50,
                                color: widget.activeColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
