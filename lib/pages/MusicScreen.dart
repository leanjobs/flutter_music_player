import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:MyMusic/constants/string.dart';
import 'package:MyMusic/models/music.dart';
import 'package:spotify/spotify.dart' as spotify;
import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicScreen extends StatefulWidget {
  final List<Music> musics;
  final int initialTrackIndex;

  const MusicScreen({
    Key? key,
    required this.musics,
    this.initialTrackIndex = 0,
  }) : super(key: key);

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final player = AudioPlayer();
  late Music music;
  late int currentTrackIndex;

  @override
  void initState() {
    super.initState();
    currentTrackIndex = widget.initialTrackIndex;
    music = widget.musics[currentTrackIndex];
    _initAsync();

    @override
    void dispose() {
      super.dispose();
      player.stop();
    }
  }

  Future<void> _initAsync() async {
    final credentials = spotify.SpotifyApiCredentials(
      CustomStrings.clientId,
      CustomStrings.clientSecret,
    );
    final spotifyApi = spotify.SpotifyApi(credentials);
    final yt = YoutubeExplode();
    final video =
        (await yt.search.search("${music.musicName} ${music.musicArtist}"))
            .first;
    music.duration = video.duration;
    final videoId = video.id.value;
    music.duration = video.duration;
    // setState(() {});
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var audioUrl = manifest.audioOnly.last.url;
    print("audiooooooo : ${audioUrl}");
    setState(() {
      currentTrackIndex = widget.initialTrackIndex;
    });
    player.play(UrlSource(audioUrl.toString()));
  }

  Future<void> _playNextTrack() async {
    if (currentTrackIndex < widget.musics.length - 1) {
      currentTrackIndex++; // Update current track index
      music = widget.musics[currentTrackIndex]; // Update current album
      await _initAsync();
      setState(() {});
    } else {
      currentTrackIndex = 0; // Loop back to the first track
      music = widget.musics[currentTrackIndex];
      await _initAsync();
      await player.stop();
      setState(() {});
    }
  }

  Future<void> _playPreviousTrack() async {
    if (currentTrackIndex > 0) {
      currentTrackIndex--; // Update current track index
      music = widget.musics[currentTrackIndex]; // Update current album
      await _initAsync(); // Initialize the previous track
      setState(() {});
    } else {
      // Handle case when there's no previous track
      // For example, you might want to loop back to the last track
      currentTrackIndex = widget.musics.length - 1;
      music = widget.musics[currentTrackIndex];
      await _initAsync();
      await player.stop();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.03,
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: AppBar(
                  title: Text(
                    'Now Playing',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await player.stop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  )),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                border: Border.all(
                  color: Color(0xFF1E9FE0).withOpacity(0.5),
                  width: 12,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.network(
                  music.musicImage ?? '',
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(
                // vertical: MediaQuery.of(context).size.height * 0.08,
                horizontal: MediaQuery.of(context).size.width * 0.08,
              ),
              child: Text(
                music.musicName ?? '',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                // vertical: MediaQuery.of(context).size.height * 0.08,
                horizontal: MediaQuery.of(context).size.width * 0.08,
              ),
              child: Text(
                music.musicArtist ?? '',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.03,
                horizontal: MediaQuery.of(context).size.width * 0.08,
              ),
              child: StreamBuilder(
                  stream: player.onPositionChanged,
                  builder: (context, data) {
                    return ProgressBar(
                      progress: data.data ?? const Duration(seconds: 0),
                      total: music.duration ?? const Duration(minutes: 2),
                      bufferedBarColor: Colors.white,
                      baseBarColor: Colors.grey,
                      thumbColor: Color(0xFF1E9FE0),
                      timeLabelTextStyle: const TextStyle(color: Colors.white),
                      progressBarColor: Color.fromARGB(255, 74, 190, 248),
                      onSeek: (duration) {
                        player.seek(duration);
                      },
                    );
                  }),
            ),
            Container(
              decoration: BoxDecoration(
                  // color: Color(0xFF333645),
                  borderRadius: BorderRadius.circular(40)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _playPreviousTrack,
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(50),
                  //     color: Color(0xFF1E9FE0),
                  //   ),
                  //   child:
                  //       Icon(Icons.play_arrow, color: Colors.white, size: 80),
                  // ),
                  IconButton(
                    onPressed: () async {
                      if (player.state == PlayerState.playing) {
                        await player.pause();
                      } else {
                        await player.resume();
                      }
                      setState(() {});
                    },
                    icon: Icon(
                      player.state == PlayerState.playing
                          ? Icons.pause
                          : Icons.play_circle,
                      color: Color(0xFF1E9FE0),
                      size: 100,
                    ),
                  ),
                  IconButton(
                    onPressed: _playNextTrack,
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  // Icon(
                  //   Icons.favorite_border,
                  //   size: 30,
                  //   color: Color(0xFF1E9FE0),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
