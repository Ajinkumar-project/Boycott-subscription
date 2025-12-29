class JiosaavnPlaylist{
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String discription;
  final int songcount;

  JiosaavnPlaylist({
    required this.id, 
    required this.title, 
    required this.subtitle, 
    required this.image, 
    required this.discription, 
    required this.songcount});


    factory JiosaavnPlaylist.fromJson(Map<String,dynamic> json){
      return JiosaavnPlaylist(
        id: json['listid']??'', 
        title: json['listname']??'', 
        subtitle: json['subtitle']??'', 
        image: json['image']??'https://static.vecteezy.com/system/resources/previews/014/142/106/original/simple-music-logo-design-concept-vector.jpg', 
        discription: json['discription']??'', 
        songcount: int.tryParse(json['list_count']?? '0')?? 0);
    }

  void operator +(JiosaavnPlaylist other) {}
}