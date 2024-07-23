import 'package:flutter/material.dart';
import 'package:MyMusic/constants/string.dart';
import 'package:MyMusic/models/music.dart';
import 'package:MyMusic/models/playlist.dart';
import 'package:MyMusic/pages/DetailPlaylistScreen.dart';
import 'package:MyMusic/pages/MusicScreen.dart';
import 'package:spotify/spotify.dart' as spotify;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Music>> _getNewReleases() async {
    final credentials = spotify.SpotifyApiCredentials(
      CustomStrings.clientId,
      CustomStrings.clientSecret,
    );
    final spotifyApi = spotify.SpotifyApi(credentials);

    final newReleases = await spotifyApi.browse.getNewReleases().getPage(20);
    final List<Music> musics = [];
    for (final music in newReleases.items!) {
      // String? imageUrl = music.images?.first.url ?? '';
      musics.add(Music(
        musicId: music.id ?? '',
        musicName: music.name ?? '',
        // musicImage = music.images?.first.url ?? '',
        // musicImage: imageUrl,
        musicImage: music.images?.first.url,
        musicArtist: music.artists?.first.name ?? '',
      ));
      print(
          "music : ${music.releaseDate}  artis : ${music.artists?.first.name ?? ""}   ${music.images?.first.url ?? ''}");
    }

    return musics;
  }

  Future<List<MyPlaylist>> _getFeaturedPlaylist() async {
    final credentials = spotify.SpotifyApiCredentials(
      CustomStrings.clientId,
      CustomStrings.clientSecret,
    );
    final spotifyApi = spotify.SpotifyApi(credentials);
    final featuredPlaylist = await spotifyApi.playlists.featured.getPage(16);
    final List<MyPlaylist> Myplaylist = [];
    for (final item in featuredPlaylist.items!) {
      Myplaylist.add(MyPlaylist(
          playlistId: item.id,
          playlistName: item.name,
          playlistImage: item.images!.first.url ?? ''));
      print(
          "idddd : ${item.id} name : ${item.name} img : ${item.images?.first.url ?? ''}");
    }
    return Myplaylist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.wait([_getFeaturedPlaylist(), _getNewReleases()]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playlistNames = snapshot.data?[0] as List<MyPlaylist>;
              final musicNames = snapshot.data?[1] as List<Music>;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.03,
                          horizontal: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Discover",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  "For you",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              "images/onlyLogo.png",
                              width: 80,
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: playlistNames
                              .asMap()
                              .map((index, playlist) {
                                final music = musicNames[index];
                                return MapEntry(
                                  index,
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailPlaylistScreen(
                                                    playlist: playlist,
                                                    musics: music,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            // color: Colors.grey.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        width: 180,
                                        child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.network(
                                                  playlist.playlistImage ?? '',
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                playlist.playlistName ?? '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Metropolis',
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                // textAlign: TextAlign.left,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                              .values
                              .toList(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          // vertical: MediaQuery.of(context).size.height * 0.01,
                          horizontal: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "New Realese",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.03,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: musicNames
                                .asMap()
                                .map((index, music) {
                                  return MapEntry(
                                    index,
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 15,
                                      ),
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
                                                      // music.musicName!.length > 21
                                                      //     ? '${music.musicName!.substring(0, 21)}...'
                                                      //     : music.musicName ?? '',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Metropolis',
                                                      ),
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
                                                        fontSize: 15,
                                                        fontFamily:
                                                            'Metropolis',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
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
                                            onPressed: () {
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
                                  );
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error:nfgnfg ${snapshot.error}');
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
