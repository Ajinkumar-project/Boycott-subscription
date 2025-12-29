import 'dart:async';

import 'package:boycott_subscription/Bloc/bloc_model.dart';
import 'package:boycott_subscription/Song_Data/playingSong.dart';
import 'package:boycott_subscription/Ui/player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:just_audio/just_audio.dart';

class Miniplayer extends StatelessWidget {
   Miniplayer({super.key, required this.player, required this.color});
   final AudioPlayer player ; 
   final unescape = HtmlUnescape() ;
   final Color color;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    Timer? _indexTimer;
// ignore: no_leading_underscores_for_local_identifiers
int? _lastIndex;

Future<int> stableInt(int index, {Duration delay = const Duration(seconds: 1)}) async {
  _lastIndex = index;

  _indexTimer?.cancel();

  final completer = Completer<int>();

  _indexTimer = Timer(delay, () {
    completer.complete(_lastIndex!);
  });

  return completer.future;
}
    return BlocBuilder<Apptheam , bool>(
      builder: (context , isdark) {
        return BlocBuilder<Isplaying , bool>(
          builder: (context , status) {
              if(status == false){
                 return const SizedBox.shrink(); 
              }else{
            return BlocListener<PlayIndex , int>(
              listener: (BuildContext context, int state)async { 
                final stableIndex = await stableInt(state);
              
                   // ignore: use_build_context_synchronously
                   context.read<Lyrices>().setLyrics(unescape.convert(nowplayingdata[stableIndex].title ), nowplayingdata[stableIndex].primaryArtists , nowplayingdata[stableIndex].primaryArtists.length >=15 ? nowplayingdata[stableIndex].language:nowplayingdata[stableIndex].primaryArtists );
             
              
               },
              child: BlocBuilder<PlayIndex , int>(
                builder: (context , currentint){
                  
                  
                  return GestureDetector(onTap: () {
                     Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlayerPage(songdata: nowplayingdata, player: player, ),
                                ),
                              );
                  },
                    child: AnimatedContainer(
                      decoration: BoxDecoration(color:  isdark? Colors.black87 : Colors.purple[50],borderRadius: BorderRadius.circular(10),boxShadow: [
                        BoxShadow(
                          color: color,blurRadius: 30,spreadRadius: 1,blurStyle: BlurStyle.outer
                        ),
                        BoxShadow(
                          color: color,blurRadius: 0.5,spreadRadius: 0.4,blurStyle: BlurStyle.outer
                        ),
                        BoxShadow(
                          color: color,blurRadius: 0.5,spreadRadius: 0.4,blurStyle: BlurStyle.outer
                        ),
                        BoxShadow(
                          color: color,blurRadius: 0.5,spreadRadius: 0.4,blurStyle: BlurStyle.outer
                        )
                      ]
                      ),
                      duration: Duration(seconds: 1),
                      height: 60,
                      width: 370,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            child: Image.network(
                              nowplayingdata[currentint].image,
                              height: 60,width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 212,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8,left: 8),
                                  child: Text(unescape.convert(nowplayingdata[currentint].title),maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1,left: 8),
                                  child: Text(nowplayingdata[currentint].primaryArtists,maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            )),
                                ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (player.playing == true) {
                                  player.pause();
                                } else {
                                  player.play();
                                }
                              },
                              icon: StreamBuilder(
                                stream: player.playingStream,
                                builder: (context, asyncSnapshot) {
                                  return Icon(
                                    asyncSnapshot.data ?? false
                                        ? Icons.pause
                                        : Icons.play_arrow_rounded,
                                  );
                                },
                              ),
                              color: color,
                            ),
                            IconButton(
                              onPressed: () {
                                player.seekToNext();
                                context.read<Lyrices>().empty();
                                context.read<PlayIndex>().current(player);
                              },
                              icon: Icon(Icons.skip_next_rounded),
                              color: color,
                            ),
                          ],
                        ),
                      ),
                  );
                  },
              ),
            );}
          }
        );
      }
    );
  }
}
