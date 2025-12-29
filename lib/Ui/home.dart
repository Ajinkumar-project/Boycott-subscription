import 'package:boycott_subscription/Bloc/bloc_model.dart';
import 'package:boycott_subscription/Song_Data/playingSong.dart';
import 'package:boycott_subscription/Ui/miniPlayer.dart';
import 'package:boycott_subscription/Ui/search.dart';
import 'package:boycott_subscription/main.dart';
import 'package:boycott_subscription/Song_Data/playlist_collection.dart';
import 'package:boycott_subscription/Ui/song_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.player});
  final AudioPlayer player ;
 

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveColor , int>(
      builder: (context , activeColor) {
        return BlocBuilder<Apptheam , bool>(
          builder: (context , isdark) {
            return Scaffold(
              backgroundColor: isdark ? bgcolor:Colors.white,
              drawer: Drawer(
                backgroundColor: isdark ? bgcolor:Colors.white ,
            child: 
                 BlocBuilder<Apptheam , bool>(
                   builder: (context , isdark1 ) {
                     return ListView(
                      children:  [
                        SwitchListTile(
                          activeThumbColor:Color(activeColor) ,
                          activeTrackColor:Colors.white38,
                          value:isdark, onChanged: (newbool){
                          context.read<Apptheam>().darkmode(newbool);
                        },
                        title: Text("Dark Mode",style: TextStyle(color: Color(activeColor)),),
                        ),
                        ListTile(
                          title: Text("Active Color",style: TextStyle(color: Color(activeColor)),),
                          trailing: DropdownButton(
                            dropdownColor: isdark? Colors.black : Colors.purple[50],
                            underline: Container(height: 0,color: Color(activeColor),),
                            value: activeColor,
                            items: [
                            DropdownMenuItem(value: Colors.pinkAccent.toARGB32(),child: Text("PinkAccent",style: TextStyle(color: Colors.pinkAccent)),),
                            DropdownMenuItem(value: Colors.redAccent.toARGB32(),child: Text("RedAccent",style: TextStyle(color: Colors.redAccent)) ,),
                            DropdownMenuItem(value: Colors.indigoAccent.toARGB32(),child: Text("indigoAccent",style: TextStyle(color: Colors.indigoAccent)) ,),
                            DropdownMenuItem(value: Colors.deepPurpleAccent.toARGB32(),child: Text("deepPurpleAccent",style: TextStyle(color: Colors.deepPurpleAccent)) ,),
                            DropdownMenuItem(value: Colors.cyanAccent.toARGB32(),child: Text("cyanAccent",style: TextStyle(color: Colors.cyanAccent)) ,),
                            DropdownMenuItem(value: Colors.greenAccent.shade400.toARGB32(),child: Text("greenAccent",style: TextStyle(color: Colors.greenAccent.shade400)) ,)
                          ], onChanged: (n){
                            context.read<ActiveColor>().activeColor(n! );
                          }),
                        )
                      ],
                             );
                   }
                 ),
              ),
              appBar: AppBar(
                backgroundColor: isdark ? bgcolor:Colors.white,
                leading: Builder(
                  builder: (context) {
                    return IconButton(onPressed: (){
                      Scaffold.of(context).openDrawer();
                    }, icon: Icon(Icons.menu_rounded) , color: Color(activeColor),);
                  }
                ),
                actions: [
                  IconButton(onPressed: (){
                    showSearch(context: context, delegate: Search(player: player, colors: isdark ? bgcolor:Colors.white, color: Color(activeColor) , ));
                  }, icon: Icon(Icons.search ,color: Color(activeColor),))
                ],
                title: Text(
                  "Music Api",
                  style: TextStyle(
                    color: Color(activeColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              body: Stack(
                children: [
                  
                  ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Favorite",
                        style: TextStyle(
                          color: Color(activeColor),
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),),
                      ),
                      SizedBox(
                        height: 260,
                        child: FutureBuilder(
                          future: Future(loadFavoriteSongs),
                          builder: (context, asyncSnapshot) {
                            return GridView(
                              scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    
                                    mainAxisExtent: 200,
                                    crossAxisCount: 1,
                                  ),
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SongListView(
                                              playlistid: "FAV",
                                              playlistTitle: "Favorite Songs", player: player, searchdata: [],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            child: ClipRRect(
                                              borderRadius: BorderRadiusGeometry.circular(8),
                                              child: Image.network(
                                                'https://static.vecteezy.com/system/resources/previews/014/142/106/original/simple-music-logo-design-concept-vector.jpg'
                                                ,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Favorite",
                                            style: TextStyle(
                                              color: Color(activeColor),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            "Song Count- ${favoriteSongs.length}",
                                            style: TextStyle(
                                              color: Color(activeColor),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                   );
                          }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Trending Playlist",
                        style: TextStyle(
                          color: Color(activeColor),
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),),
                      ),
                      SizedBox(
                        height: 290,
                        child: FutureBuilder(
                          future: Future(playlistcollections),
                          builder: (context, snapshort) {
                            return GridView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: playlistcollection.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                
                                mainAxisExtent: 200,
                                crossAxisCount: 1,
                              ),
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongListView(
                                          playlistid: playlistcollection[index].id,
                                          playlistTitle: playlistcollection[index].title, player: player, searchdata: [],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(8),
                                          child: Image.network(
                                            playlistcollection[index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        playlistcollection[index].title,
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Song Count- ${playlistcollection[index].songcount}",
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Top Genres & Moods- Tamil",
                        style: TextStyle(
                          color: Color(activeColor),
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),),
                      ),
                      SizedBox(
                        height: 290,
                        child: FutureBuilder(
                          future: Future(topGenresTamil),
                          builder: (context, snapshort) {
                            return GridView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: topGenreTamil.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                
                                mainAxisExtent: 200,
                                crossAxisCount: 1,
                              ),
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongListView(
                                          playlistid: topGenreTamil[index].id,
                                          playlistTitle: topGenreTamil[index].title, player: player, searchdata: [],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(8),
                                          child: Image.network(
                                            topGenreTamil[index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        topGenreTamil[index].title,
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Song Count- ${topGenreTamil[index].songcount}",
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Top Genres & Moods- Malayalam",
                        style: TextStyle(
                          color: Color(activeColor),
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),),
                      ),
                      SizedBox(
                        height: 290,
                        child: FutureBuilder(
                          future: Future(topGenresMalayalam),
                          builder: (context, snapshort) {
                            return GridView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: topGenreMalayalam.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                
                                mainAxisExtent: 200,
                                crossAxisCount: 1,
                              ),
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongListView(
                                          playlistid: topGenreMalayalam[index].id,
                                          playlistTitle: topGenreMalayalam[index].title, player: player, searchdata: [],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(8),
                                          child: Image.network(
                                            topGenreMalayalam[index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        topGenreMalayalam[index].title,
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Song Count- ${topGenreMalayalam[index].songcount}",
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Top Genres & Moods- Hindi",
                        style: TextStyle(
                          color: Color(activeColor),
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),),
                      ),
                      SizedBox(
                        height: 290,
                        child: FutureBuilder(
                          future: Future(topGenresHindi),
                          builder: (context, snapshort) {
                            return GridView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: topGenreHindi.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                
                                mainAxisExtent: 200,
                                crossAxisCount: 1,
                              ),
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongListView(
                                          playlistid: topGenreHindi[index].id,
                                          playlistTitle: topGenreHindi[index].title, player: player, searchdata: [],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(8),
                                          child: Image.network(
                                            topGenreHindi[index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        topGenreHindi[index].title,
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Song Count- ${topGenreHindi[index].songcount}",
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Top Genres & Moods- English",
                        style: TextStyle(
                          color: Color(activeColor),
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),),
                      ),
                      SizedBox(
                        height: 290,
                        child: FutureBuilder(
                          future: Future(topGenresEnglish),
                          builder: (context, snapshort) {
                            return GridView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: topGenreEnglish.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                
                                mainAxisExtent: 200,
                                crossAxisCount: 1,
                              ),
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongListView(
                                          playlistid: topGenreEnglish[index].id,
                                          playlistTitle: topGenreEnglish[index].title, player: player, searchdata: [],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(8),
                                          child: Image.network(
                                            topGenreEnglish[index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        topGenreEnglish[index].title,
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Song Count- ${topGenreEnglish[index].songcount}",
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Editor's Picks",
                        style: TextStyle(
                          color: Color(activeColor),
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),),
                      ),
                      SizedBox(
                        height: 290,
                        child: FutureBuilder(
                          future: Future(editorsPick),
                          builder: (context, snapshort) {
                            return GridView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: editorPick.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                
                                mainAxisExtent: 200,
                                crossAxisCount: 1,
                              ),
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongListView(
                                          playlistid: editorPick[index].id,
                                          playlistTitle: editorPick[index].title, player: player, searchdata: [],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(8),
                                          child: Image.network(
                                            editorPick[index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        editorPick[index].title,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Song Count- ${editorPick[index].songcount}",
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Fresh Hits",
                        style: TextStyle(
                          color: Color(activeColor),
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),),
                      ),
                      SizedBox(
                        height: 290,
                        child: FutureBuilder(
                          future: Future(freshHit),
                          builder: (context, snapshort) {
                            return GridView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: freshHits.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                
                                mainAxisExtent: 200,
                                crossAxisCount: 1,
                              ),
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongListView(
                                          playlistid: freshHits[index].id,
                                          playlistTitle: freshHits[index].title, player: player, searchdata: [],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(8),
                                          child: Image.network(
                                            freshHits[index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        freshHits[index].title,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Song Count- ${freshHits[index].songcount}",
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text("Top K-Pop",
                        style: TextStyle(
                          color: Color(activeColor),
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),),
                      ),
                      SizedBox(
                        height: 290,
                        child: FutureBuilder(
                          future: Future(topKPop),
                          builder: (context, snapshort) {
                            return GridView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: topKPops.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                
                                mainAxisExtent: 200,
                                crossAxisCount: 1,
                              ),
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongListView(
                                          playlistid: topKPops[index].id,
                                          playlistTitle: topKPops[index].title, player: player, searchdata: [],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(8),
                                          child: Image.network(
                                            topKPops[index].image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        topKPops[index].title,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Song Count- ${topKPops[index].songcount}",
                                        style: TextStyle(
                                          color: Color(activeColor),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(alignment: Alignment(0.0 ,0.95),
                    child: Miniplayer(player: player, color: Color(activeColor),)),
                ],
              ),
            );
          }
        );
      }
    );
  }
}
