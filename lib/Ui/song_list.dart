
import 'package:boycott_subscription/Bloc/bloc_model.dart';
import 'package:boycott_subscription/Ui/miniPlayer.dart';
import 'package:boycott_subscription/Ui/player_page.dart';
import 'package:boycott_subscription/main.dart';
import 'package:boycott_subscription/Song_Data/playingSong.dart';
import 'package:boycott_subscription/API_Calls/playlist&song_fetcher.dart';
import 'package:boycott_subscription/Models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class SongListView extends StatelessWidget {
  const SongListView({super.key, required this.playlistid, required this.playlistTitle, required this.player, required this.searchdata});
  final AudioPlayer player ;
  final String playlistid;
  final String playlistTitle;
  final List<JioSaavnSong> searchdata;
  
  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    String to500(String url) {
      return url.replaceAll(RegExp(r'\d+x\d+'), '500x500');
    }
    void playsong( int index) async {
       // ✅ Keep your existing Bloc logic
  // ignore: use_build_context_synchronously
  context.read<Position>().position(player);
  // ignore: use_build_context_synchronously
  context.read<SongDuration>().duration(player);
  // final playIndex = context.read<PlayIndex>().state;
         
  // ✅ Build a hidden playlist from your nowplayingdata
  // ignore: deprecated_member_use
  final playlist = ConcatenatingAudioSource(
    children: List.generate(nowplayingdata.length, (index) {
      final song = nowplayingdata[index];

      return AudioSource.uri(
        Uri.parse(song.decryptedMediaUrl), // ✅ use each song’s real URL
        tag: MediaItem(
          id: index.toString(),
          title: unescape.convert(song.title),
          artist: unescape.convert(song.primaryArtists),
              artUri: Uri.parse(to500(song.image)),
            ),
          );
        }),
      );
      await player.stop();
      // ✅ Start playing from the selected index

      // ignore: use_build_context_synchronously
      context.read<Isplaying>().isplaying(true);
      await player.setAudioSource(
        preload: false,
        playlist,
        initialIndex: index,
        initialPosition: Duration.zero,
      );

      await player.play();

 
}


    List<JioSaavnSong> songdata =[];
    void songFinder() async {
      final songs = await PlaylistSongAPI.fetchSongs(playlistid);
      songdata = songs;
    }


    if(playlistid == "FAV"){
      return BlocBuilder<ActiveColor , int>(
        builder: (context , activeColor) {
          return BlocBuilder<Apptheam , bool>(
            builder: (context , isdark) {
              return Scaffold(
                backgroundColor: isdark ? bgcolor:Colors.white,
              appBar: AppBar(
                 backgroundColor: isdark ? bgcolor:Colors.white,
                title: Text(
                  playlistTitle,
                  style: TextStyle(
                    color: Color(activeColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              body: FutureBuilder(
                future: Future(loadFavoriteSongs),
                builder: (context, snapshot) {
                  if(favoriteSongs.isEmpty){
                    return Center(child: Text("No song found"),);
                  }else{
              
                  return BlocBuilder<PlayIndex , int>(
                    builder: (context , playIndex) {
                      return Stack(
                        children: [
                          ListView.builder(
                            itemCount: favoriteSongs.length,
                            itemBuilder: (context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: isdark? Colors.white10 : Colors.purple[50],
                                ),
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(8),
                                child: ListTile(
                                  title: Text(
                                    unescape.convert(favoriteSongs[index].title),
                                    maxLines: 1,
                                    style: TextStyle(color: Color(activeColor), fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(favoriteSongs[index].primaryArtists,maxLines: 2,),
                                leading: ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(8),
                                  child: Image.network(favoriteSongs[index].image,fit: BoxFit.cover,),
                                ),
                                onTap: () async {
                                  
                                    nowplayingdata = favoriteSongs;
                                    context.read<Lyrices>().empty();
                                    context.read<PlayIndex>().playindex(index);
                                    playsong(index);  
                                     context.read<Lyrices>().setLyrics(
                  unescape.convert(nowplayingdata[index].title),
                    nowplayingdata[index].primaryArtists,
                    nowplayingdata[index].primaryArtists.length >= 15
                        ? nowplayingdata[index].language
                        : nowplayingdata[index].primaryArtists,
                  );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlayerPage(songdata: nowplayingdata, player: player, ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          Align(alignment: Alignment(0.0 ,0.95),
                    child: Miniplayer(player: player, color: Color(activeColor),)),
                        ],
                      );
                    },
                  );}
                }
              ),
                  );
            }
          );
        }
      );


    }

    if(playlistid == "Search"){
          return  BlocBuilder<ActiveColor , int>(
            builder: (context , activeColor) {
              return BlocBuilder<Apptheam , bool>(
                builder: (context , isdark) {
                  return ListView.builder(
                        itemCount: searchdata.length,
                        itemBuilder: (context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isdark? Colors.white10 : Colors.purple[50],
                            ),
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(
                                unescape.convert(searchdata[index].title),
                                maxLines: 1,
                                style: TextStyle(color: Color(activeColor), fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(searchdata[index].primaryArtists,maxLines: 2,),
                            leading: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(8),
                              child: Image.network(searchdata[index].image,fit: BoxFit.cover,),
                            ),
                            onTap: () async {
                              
                                nowplayingdata = searchdata;
                                context.read<Lyrices>().empty();
                                context.read<PlayIndex>().playindex(index);
                                playsong(
                                  index
                                );
                                 context.read<Lyrices>().setLyrics(
                  unescape.convert(nowplayingdata[index].title),
                    nowplayingdata[index].primaryArtists,
                    nowplayingdata[index].primaryArtists.length >= 15
                        ? nowplayingdata[index].language
                        : nowplayingdata[index].primaryArtists,
                  );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlayerPage(songdata: nowplayingdata, player: player, ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                }
              );
            }
          );
    }
    
    
    else{

    return BlocBuilder<ActiveColor , int>(
      builder: (context, activeColor) {
        return BlocBuilder<Apptheam , bool>(
          builder: (context, isdark) {
            return Scaffold(
              backgroundColor: isdark ? bgcolor:Colors.white,
              appBar: AppBar(
                 backgroundColor: isdark ? bgcolor:Colors.white,
                title: Text(
                  playlistTitle,
                  style: TextStyle(
                    color: Color(activeColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              body: Stack(
                children: [
                  FutureBuilder(
                    future: Future(songFinder),
                    builder: (context, snapshot) {
                      return BlocBuilder<PlayIndex , int>(
                        builder: (context , playIndex) {
                          return ListView.builder(
                            itemCount: songdata.length,
                            itemBuilder: (context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: isdark? Colors.white10 : Colors.purple[50],
                                ),
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(8),
                                child: ListTile(
                                  title: Text(
                                    unescape.convert(songdata[index].title),
                                    maxLines: 1,
                                    style: TextStyle(color: Color(activeColor), fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(songdata[index].primaryArtists,maxLines: 2,),
                                leading: ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(8),
                                  child: Image.network(songdata[index].image,fit: BoxFit.cover,),
                                ),
                                onTap: () async {
                                  
                                    nowplayingdata = songdata;
                                    context.read<Lyrices>().empty();
                                    context.read<PlayIndex>().playindex(index);
                                    playsong(
                                      index
                                    );
                                    context.read<Lyrices>().setLyrics(
                  unescape.convert(nowplayingdata[index].title),
                    nowplayingdata[index].primaryArtists,
                    nowplayingdata[index].primaryArtists.length >= 15
                        ? nowplayingdata[index].language
                        : nowplayingdata[index].primaryArtists,
                  );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlayerPage(songdata: nowplayingdata, player: player, ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  ),
                  Align(alignment: Alignment(0.0 ,0.95),
                    child: Miniplayer(player: player, color: Color(activeColor),)),
                ],
              ),
            );
          }
        );
      }
    );}
  }
}