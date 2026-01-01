import 'package:boycott_subscription/Bloc/bloc_model.dart';
import 'package:boycott_subscription/Lyrics/full_lyrics.dart';
import 'package:boycott_subscription/Lyrics/id&lrc_convertor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class LyricPage extends StatelessWidget {
  const LyricPage({super.key, required this.color, required this.player});
  final Color color;
  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<Position, Duration>(
        builder: (context, position) {
          return BlocBuilder<Lyrices, List<LyricLine>>(
            builder: (context, lyrics) {
              return Fulllyx(
                lyrics: lyrics,
                position: position,
                activeColor: color, player: player,
              );
            },
          );
        },
      ),
    );
  }
}
