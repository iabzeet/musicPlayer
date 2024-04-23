import 'package:flutter/material.dart';
import 'package:playerofsongs/components/neu_box.dart';
import 'package:playerofsongs/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({Key? key}) : super(key: key);

  //convert duration into min:sec
  String formatTime(Duration duration) {
    String twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        final playlist = playlistProvider.playlist;
        final currentSongIndex = playlistProvider.currentSongIndex ?? 0;
        final currentSong = playlist[currentSongIndex];
        final currentDuration = playlistProvider.currentDuration;
        final totalDuration = playlistProvider.totalDuration;
        final isPlaying = playlistProvider.isPlaying;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text("P L A Y L I S T"),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Album artwork
                  NeuBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),
                        // Song and artist name and icon
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Song and artist name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),
                              // Heart icon
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Song duration progress
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Start time
                            Text(formatTime(playlistProvider.currentDuration)),
                            // Shuffle icon
                            const Icon(Icons.shuffle),
                            // Repeat icon
                            const Icon(Icons.repeat),
                            // End time
                            Text(formatTime(playlistProvider.totalDuration)),
                          ],
                        ),
                      ),
                      // Song duration progress slider
                      Slider(
                        min: 0,
                        max: totalDuration.inSeconds.toDouble(),
                        value: currentDuration.inSeconds.toDouble(),
                        activeColor: Colors.green,
                        onChanged: (value) {
                          playlistProvider.seek(Duration(seconds: value.toInt()));
                        },
                        onChangeEnd: (value) {
                          playlistProvider.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Playback controls
                  Row(
                    children: [
                      // Skip previous button
                      Expanded(
                        child: GestureDetector(
                          onTap: playlistProvider.playPreviousSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Play/pause button
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: playlistProvider.pauseOrResume,
                          child: NeuBox(
                            child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Skip forward button
                      Expanded(
                        child: GestureDetector(
                          onTap: playlistProvider.playNextSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
