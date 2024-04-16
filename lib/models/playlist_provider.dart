import 'package:flutter/material.dart';
import 'package:playerofsongs/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  //playlist of songs
  final List<Song> _playlist = [
    //song 1
    Song(
      songName: "I Ain't Worrried",
      artistName: "OneRepublic",
      albumArtImagePath: "assets/images/first.jpg",
      audioPath: "audio/IAintWorried.mp3",
    ),

    //song 2
    Song(
      songName: "Native",
      artistName: "OneRepublic",
      albumArtImagePath: "assets/images/second.jpg",
      audioPath: "audio/IAintWorried.mp3",
    ),

    //song 3
    Song(
      songName: "Wanted",
      artistName: "OneRepublic",
      albumArtImagePath: "assets/images/third.jpg",
      audioPath: "audio/IAintWorried.mp3",
    ),
  ];

  //current song playing index
  int? _currentSongIndex;

  /*

  G E T T E R S

  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;

  /*

  S E T T E R S

  */

  set currentSongIndex(int? newIndex) {

    //update current song index
    _currentSongIndex = newIndex;

    //update UI
    notifyListeners();
  }
}