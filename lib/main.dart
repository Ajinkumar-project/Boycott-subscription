import 'dart:async';
import 'package:boycott_subscription/Bloc/bloc_model.dart';
import 'package:boycott_subscription/Downloads/song_pipeline_service.dart';
import 'package:boycott_subscription/Song_Data/playingSong.dart';
import 'package:boycott_subscription/Ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:metadata_god/metadata_god.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await MetadataGod.initialize();
  await MediaStore.ensureInitialized();
  MediaStore.appFolder = "Boycott Music";
  await Hive.initFlutter();
  await Hive.openBox("favorite");
  await Hive.openBox('settings');
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
final  service =SongPipelineService();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<PlayIndex>(
      create: (BuildContext context) => PlayIndex(),
    ),
    BlocProvider<ActiveColor>(
      create: (BuildContext context) => ActiveColor(),
    ),
    BlocProvider<Apptheam>(
      create: (BuildContext context) => Apptheam(),
    ),
     BlocProvider<Isplaying>(
      create: (BuildContext context) => Isplaying(),
    ),BlocProvider<Continueplaying>(
      create: (BuildContext context) => Continueplaying(),
    ),BlocProvider<Position>(
      create: (BuildContext context) => Position(),
    ),BlocProvider<SongDuration>(
      create: (BuildContext context) => SongDuration(),
    ), BlocProvider<Seeker>(
      create: (BuildContext context) => Seeker(),
    ),BlocProvider<Lyrices>(
      create: (BuildContext context) => Lyrices(),
    ),
    BlocProvider<SongDownloads>(
      create: (BuildContext context) => SongDownloads(
          service
      ),
    ),
    ],
    child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    final currint =context.read<PlayIndex>().current(player);
    
   
    StreamSubscription<PlayerState>? playerSub;
    void pla()  {
                            // Cancel previous listener if it exists
                            playerSub?.cancel();

                            playerSub =  player.playerStateStream.listen((
                              onData,
                            ) {
                              if (onData.processingState ==
                                  ProcessingState.completed) {
                                player.seekToNext();
                               currint;

          // ignore: use_build_context_synchronously
          context.read<Lyrices>().empty();
        }
      });
    }

    pla();
    loadFavoriteSongs();
    return BlocBuilder<Apptheam , bool>(
      builder: (context, isdark) {
        return MaterialApp(
          home: Home(player: player),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: isdark ? bgcolor:Colors.white,
          ),
          themeMode:isdark? ThemeMode.dark:ThemeMode.light,
        );
      },
    );
  }
}

Color bgcolor = Colors.black;
