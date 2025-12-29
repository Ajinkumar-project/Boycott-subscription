import 'package:boycott_subscription/API_Calls/playlist&song_fetcher.dart';
import 'package:boycott_subscription/Models/playlist_model.dart';



void playlistcollections() async {
  final playlist1 = await JioSaavnAPI.fetchPlaylist("Dq3pWn1coqesud-ETNX4vg__");
  final playlist2 = await JioSaavnAPI.fetchPlaylist("1e3vU4q7bbbExeh5N5JWFg__");
  final playlist3 = await JioSaavnAPI.fetchPlaylist("aXoCADwITrUCObrEMJSxEw__");
  final playlist4 = await JioSaavnAPI.fetchPlaylist("HE0Py2gEJrXWCn-BpjaL7g__");
  final playlist5 = await JioSaavnAPI.fetchPlaylist("zlJfJYVuyjpxWb5,FqsjKg__");
  final playlist6 = await JioSaavnAPI.fetchPlaylist("4O6DwO-qteN613W6L-cCSw__");
  playlistcollection = [playlist1, playlist2, playlist3 , playlist4 ,playlist5, playlist6];
}


List<JiosaavnPlaylist> playlistcollection = [];

void topGenresTamil() async {
  final playlist1 = await JioSaavnAPI.fetchPlaylist("Le-woPWglF1ieSJqt9HmOQ__");
  final playlist2 = await JioSaavnAPI.fetchPlaylist(",9s3E3l5o0lFo9wdEAzFBA__");
  final playlist3 = await JioSaavnAPI.fetchPlaylist("P17fcUdCFo7uCJW60TJk1Q__");
  final playlist4 = await JioSaavnAPI.fetchPlaylist("2uwAUQjOVlnfemJ68FuXsA__");
  final playlist5 = await JioSaavnAPI.fetchPlaylist("vRZbZ,Y9fUkGSw2I1RxdhQ__");
  final playlist6 = await JioSaavnAPI.fetchPlaylist("n3cmM4By1StieSJqt9HmOQ__");
  final playlist7 = await JioSaavnAPI.fetchPlaylist("jMHINeLYW1eO0eMLZZxqsA__");
  final playlist8 = await JioSaavnAPI.fetchPlaylist("ksUlhKAHs8U_");
  topGenreTamil = [playlist1, playlist2, playlist3 , playlist4 ,playlist5, playlist6 ,playlist7, playlist8];
}
List<JiosaavnPlaylist> topGenreTamil = [];

void topGenresMalayalam() async {
  final playlist1 = await JioSaavnAPI.fetchPlaylist("TPzO5IY-SwHc1EngHtQQ2g__");
  final playlist2 = await JioSaavnAPI.fetchPlaylist("9Jj58jNjBZ0wkg5tVhI3fw__");
  final playlist3 = await JioSaavnAPI.fetchPlaylist("ZbLqIHd8oRVieSJqt9HmOQ__");
  final playlist4 = await JioSaavnAPI.fetchPlaylist("oOBgS3fQyv-femJ68FuXsA__");
  final playlist5 = await JioSaavnAPI.fetchPlaylist("xYTh3zxIreFieSJqt9HmOQ__");
  final playlist6 = await JioSaavnAPI.fetchPlaylist("8XHj9btcj6SdFAUQTknEXA__");
  final playlist7 = await JioSaavnAPI.fetchPlaylist("8XHj9btcj6SdFAUQTknEXA__");
  topGenreMalayalam = [playlist1, playlist2, playlist3 , playlist4 ,playlist5, playlist6, playlist7];
}
List<JiosaavnPlaylist> topGenreMalayalam = [];

void topGenresHindi() async {
  final playlist1 = await JioSaavnAPI.fetchPlaylist("xHa-oM3ldXAwkg5tVhI3fw__");
  final playlist2 = await JioSaavnAPI.fetchPlaylist("WjjhR,A3iLLuCJW60TJk1Q__");
  final playlist3 = await JioSaavnAPI.fetchPlaylist("1rsxc6d-ReGTb7czG7lKZg__");
  final playlist4 = await JioSaavnAPI.fetchPlaylist("DByzia6eJfXuCJW60TJk1Q__");
  final playlist5 = await JioSaavnAPI.fetchPlaylist("w0I4mmvR4v5Fo9wdEAzFBA__");
  final playlist6 = await JioSaavnAPI.fetchPlaylist("mAA3xzx2Asqm0KYf4sgO,Q__");
  final playlist7 = await JioSaavnAPI.fetchPlaylist("SBKnUgjNeMIwkg5tVhI3fw__");
  topGenreHindi = [playlist1, playlist2, playlist3 , playlist4 ,playlist5, playlist6, playlist7];
}
List<JiosaavnPlaylist> topGenreHindi = [];

void topGenresEnglish() async {
  final playlist1 = await JioSaavnAPI.fetchPlaylist("oqKee-6aXESO0eMLZZxqsA__");
  final playlist2 = await JioSaavnAPI.fetchPlaylist("ADWcBikKwKTufxkxMEIbIw__");
  final playlist3 = await JioSaavnAPI.fetchPlaylist("l-B,YKTNVVc_");
  final playlist4 = await JioSaavnAPI.fetchPlaylist("AMoxtXyKHoU_");
  final playlist5 = await JioSaavnAPI.fetchPlaylist("2PpAnU1KPVDflAdLIHj8iA__");
  final playlist6 = await JioSaavnAPI.fetchPlaylist("zfs3622ON9HfemJ68FuXsA__");
  final playlist7 = await JioSaavnAPI.fetchPlaylist("v6gwjI,5dnc_?");
  topGenreEnglish = [playlist1, playlist2, playlist3 , playlist4 ,playlist5, playlist6, playlist7];
}
List<JiosaavnPlaylist> topGenreEnglish = [];



void editorsPick() async {
  final playlist1 = await JioSaavnAPI.fetchPlaylist("T0Uq4vn2byc_");
  final playlist2 = await JioSaavnAPI.fetchPlaylist("tfVkYjaAbZJieSJqt9HmOQ__");
  final playlist3 = await JioSaavnAPI.fetchPlaylist(",0LuibvpGl4_");
  final playlist4 = await JioSaavnAPI.fetchPlaylist("-KAZYpBulyM_");
  final playlist5 = await JioSaavnAPI.fetchPlaylist("EsbCWUC3q5Ewkg5tVhI3fw__");
  final playlist6 = await JioSaavnAPI.fetchPlaylist("ZodsPn39CSjwxP8tCU-flw__");
  final playlist7 = await JioSaavnAPI.fetchPlaylist("7e2LtwVBX6JFo9wdEAzFBA__");
  editorPick = [playlist1, playlist2, playlist3 , playlist4 ,playlist5, playlist6, playlist7];
}
List<JiosaavnPlaylist> editorPick = [];

void freshHit() async {
  final playlist1 = await JioSaavnAPI.fetchPlaylist("Ns2UZo9qDvI_");
  final playlist2 = await JioSaavnAPI.fetchPlaylist("Q1POpnJeUPI_");
  final playlist3 = await JioSaavnAPI.fetchPlaylist("qd1gez-n10DuCJW60TJk1Q__");
  final playlist4 = await JioSaavnAPI.fetchPlaylist("Me5RridRfDk_");
  freshHits = [playlist1, playlist2, playlist3 , playlist4 ];
}
List<JiosaavnPlaylist> freshHits = [];



void topKPop() async {
  final playlist1 = await JioSaavnAPI.fetchPlaylist("qmcsGAI9mRFFo9wdEAzFBA__");
  final playlist2 = await JioSaavnAPI.fetchPlaylist("-,-31WVKSbiO0eMLZZxqsA__");
  final playlist3 = await JioSaavnAPI.fetchPlaylist("jPaY0eidVvNNXRw7JlcL4A__");
  final playlist4 = await JioSaavnAPI.fetchPlaylist("qjzRUxBGmMkGSw2I1RxdhQ__");
  final playlist5 = await JioSaavnAPI.fetchPlaylist("RtkMxMz4dhCO0eMLZZxqsA__");
  final playlist6 = await JioSaavnAPI.fetchPlaylist("MMswPyohsnaWfAFNItf,3Q__");
  final playlist7 = await JioSaavnAPI.fetchPlaylist("tZ6Mtzw3nourB59Sr2unUQ__");
  final playlist8 = await JioSaavnAPI.fetchPlaylist("37mlvHP4,WAaf0YbnbpnQQ__");
  topKPops = [playlist1, playlist2, playlist3 , playlist4 ,playlist5, playlist6 ,playlist7, playlist8];
}
List<JiosaavnPlaylist> topKPops = [];