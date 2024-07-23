import 'package:spotify/spotify.dart';

class MyPlaylist {
  String? playlistId;
  String? playlistName;
  String? playlistImage;
  String? playlistDesk;
  // List<Track> playlistTracks;

  MyPlaylist({
    this.playlistId,
    this.playlistName,
    this.playlistImage,
    this.playlistDesk,
    // required this.playlistTracks,
  });
}
