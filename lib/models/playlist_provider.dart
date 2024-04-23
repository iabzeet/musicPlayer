
import 'package:audioplayers/audioplayers.dart';
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

  A U D I O P L A Y E R

  */

  //audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  //durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  //constructor
  PlaylistProvider() {
    listenDuration();
  }

  //initially not playing
  bool _isPlaying = false;

  //play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); //stop current song
    await _audioPlayer.play(AssetSource(path)); //play the new song
    _isPlaying = true;
    notifyListeners();
  }

  //pause the song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  //seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if(_currentSongIndex != null) {
      if(_currentSongIndex! < _playlist.length-1) {
        //go tot he next song if it's not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        //if it's the last song, loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  //play previous song
  void playPreviousSong() async {
    //if more than 2 seconds have passed, restart the current song
    if(_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    //if it's within first 2 seconds of the song, go to previous song
    else  {
      if(_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        //if its the first song, loop back to last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  //listen to duration
  void listenDuration() {
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPostion) {
      _currentDuration = newPostion;
      notifyListeners();
    });

    //listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  //dispose audio player

  /*

  G E T T E R S

  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*

  S E T T E R S

  */

  set currentSongIndex(int? newIndex) {

    //update current song index
    _currentSongIndex = newIndex;

    if(newIndex != null) {
      play(); //play hre song at the new index
    }

    //update UI
    notifyListeners();
  }
}