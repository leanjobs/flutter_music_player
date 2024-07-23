import 'package:flutter/material.dart';
import 'package:MyMusic/constants/string.dart';
import 'package:MyMusic/models/music.dart';
import 'package:MyMusic/models/playlist.dart';
import 'package:MyMusic/pages/MusicScreen.dart';
import 'package:spotify/spotify.dart' as spotify;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:MyMusic/models/playlist.dart';

class DetailPlaylistScreen extends StatefulWidget {
  final MyPlaylist playlist;
  final Music musics;
  const DetailPlaylistScreen(
      {super.key, required this.playlist, required this.musics});

  @override
  State<DetailPlaylistScreen> createState() => _DetailPlaylistScreenState();
}

class _DetailPlaylistScreenState extends State<DetailPlaylistScreen> {
  @override
  late Future<List<MyPlaylist>> _DetailPlaylist;
  late Future<List<Music>> _TrackPlaylist;

// Future<List<Playlist>> _getDetailPlaylist() async {
//     final credentials = spotify.SpotifyApiCredentials(
//       CustomStrings.clientId,
//       CustomStrings.clientSecret,
//     );
//     final spotifyApi = spotify.SpotifyApi(credentials);

//     final playlistId = widget.playlist.playlistId;
//     final playlist = await spotifyApi.playlists.get(playlistId?? '');
//     final getTracksByPlaylistId = await spotifyApi.playlists.getTracksByPlaylistId(playlist.id!).all();
//      final List<MyPlaylist> ListPlaylists = [];
//     for (final playlist in getTracksByPlaylistId){
//       ListPlaylists.add(MyPlaylist(playlistId: playlist.id?? '', playlistImage:playlist.images?.fi));
//     }
//     // for (final music in newReleases.items!) {
//     //   // String? imageUrl = music.images?.first.url ?? '';
//     //   musics.add(Playlist(
//     //     musicId: music.id ?? '',
//     //     musicName: music.name ?? '',
//     //     // musicImage = music.images?.first.url ?? '',
//     //     // musicImage: imageUrl,
//     //     musicImage: music.images?.first.url,
//     //     musicArtist: music.artists?.first.name ?? '',
//     //   ));
//     //   print(
//     //       "music : ${music.releaseDate}  artis : ${music.artists?.first.name ?? ""}   ${music.images?.first.url ?? ''}");
//     // }

//      return ListPlaylists;
//   }
  @override
  void initState() {
    super.initState();
    _DetailPlaylist = _getDetailPlaylist();
    _TrackPlaylist = _getTrackPlaylist();
  }

  Future<List<MyPlaylist>> _getDetailPlaylist() async {
    final credentials = spotify.SpotifyApiCredentials(
      CustomStrings.clientId,
      CustomStrings.clientSecret,
    );
    final spotifyApi = spotify.SpotifyApi(credentials);
    final detailPlaylist = await spotifyApi.playlists.featured.getPage(10);
    final List<MyPlaylist> ListPlaylist = [];
    for (final item in detailPlaylist.items!) {
      ListPlaylist.add(MyPlaylist(
        playlistId: item.id,
        playlistName: item.name,
        playlistDesk: item.description,
        playlistImage: item.images!.first.url ?? '',
      ));
      print(
          "idddd : ${item.id} Detail : ${item.description} img : ${item.images?.first.url ?? ''}");
    }
    return ListPlaylist;
  }

  Future<List<Music>> _getTrackPlaylist() async {
    final credentials = spotify.SpotifyApiCredentials(
      CustomStrings.clientId,
      CustomStrings.clientSecret,
    );
    final spotifyApi = spotify.SpotifyApi(credentials);
    final playlistid = widget.playlist.playlistId;
    final trackPlaylist = await spotifyApi.playlists
        .getTracksByPlaylistId(playlistid)
        .getPage(100);
    final List<Music> ListTrackPlaylist = [];
    for (final music in trackPlaylist.items!) {
      ListTrackPlaylist.add(Music(
        musicId: music.id,
        musicArtist: music.artists!.first.name,
        musicName: music.name,
        musicImage: music.album!.images!.first.url ?? '',
      ));
      // print(
      //     "music : ${music.name}  artis : ${music.artists?.first.name ?? ""}  images: ${music.album!.images!.first.url ?? ''}");
    }
    return ListTrackPlaylist;
  }

  @override
  Widget build(BuildContext context) {
    print('playlistDesk: ${widget.playlist.playlistDesk}');
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(widget.playlist.playlistImage ?? ''),
            fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF191A1E).withOpacity(0.8),
                  Color(0xFF191A1E).withOpacity(1.0),
                  Color(0xFF191A1E),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.03,
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                  ),
                  child: AppBar(
                      title: Text(
                        'Detail Playlist',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          decoration: TextDecoration.none,
                          color: Colors.white,
                        ),
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    // vertical: MediaQuery.of(context).size.height * 0.04,
                  ),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          widget.playlist.playlistImage ?? '',
                          width: MediaQuery.of(context).size.width * 0.35,
                        ),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                widget.playlist.playlistName ?? '',
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  decoration: TextDecoration.none,
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Container(
                            //   decoration: BoxDecoration(color: Colors.amber),
                            //   child: Text(
                            //     widget.playlist.playlistDesk ?? '',
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            // Text(
                            //   widget.playlist.playlistDesk ?? '',
                            //   style: TextStyle(
                            //     fontFamily: 'Metropolis',
                            //     decoration: TextDecoration.none,
                            //     color: Colors.white,
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.w900,
                            //   ),
                            //   overflow: TextOverflow.ellipsis,
                            //   maxLines: 2,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Songs",
                        style: TextStyle(
                            fontFamily: 'Metropolis',
                            decoration: TextDecoration.none,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                    future: _getTrackPlaylist(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final musicNames = snapshot.data as List<Music>;
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ListView.builder(
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: musicNames.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final music = musicNames[index];
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, bottom: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      music.musicImage ?? '',
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                    child: Text(
                                                      music.musicName ?? '',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Metropolis',
                                                          decoration:
                                                              TextDecoration
                                                                  .none),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                    child: Text(
                                                      music.musicArtist ?? '',
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Metropolis',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        decoration:
                                                            TextDecoration.none,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MusicScreen(
                                                    musics: musicNames,
                                                    initialTrackIndex: index,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.play_circle_fill_rounded,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error:nfgnfg ${snapshot.error}');
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
