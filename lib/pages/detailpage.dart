import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/thems.dart';
import '../musicController/MusicProvider.dart';
import '../musicController/modelClass/modelclass.dart';
import '../musicController/playListProvider.dart';

enum RepeatMode { off, one, all }

class DetailPage extends StatefulWidget {
  final MusicFile musicFile;
  final List<MusicFile> playlist;

  DetailPage({required this.musicFile, required this.playlist});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int currentIndex;
  RepeatMode repeatMode = RepeatMode.off;
  bool isShuffling = false;
  StreamSubscription? _onCompleteSubscription;

  @override
  void initState() {
    super.initState();
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    currentIndex = widget.playlist.indexOf(widget.musicFile);
    musicProvider.playMusic(widget.musicFile);

    _onCompleteSubscription =
        musicProvider.audioPlayer.onPlayerComplete.listen((event) {
      _playNext();
    });
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);
    final double hi = MediaQuery.of(context).size.height;
    final double wi = MediaQuery.of(context).size.width;
    Widget space = SizedBox(height: hi / 70);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: TextStyle(fontSize: hi / 45),
          musicProvider.currentMusicFile != null
              ? musicProvider.currentMusicFile!.title
              : 'No Song Playing',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StackContainer(
              text: musicProvider.currentMusicFile != null
                  ? musicProvider.currentMusicFile!.title
                  : 'No Song Playing',
              radius: 100,
              height: hi - 120,
              width: wi,
            ),
            space,
            Card(
              color: Colors.deepPurpleAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      style: TextStyle(fontSize: hi / 60),
                      _formatDuration(
                          musicProvider.currentPosition ?? Duration.zero)),
                  SizedBox(
                    width: wi / 1.5,
                    child: Slider(
                      inactiveColor: Colors.black,
                      activeColor: Colors.red,
                      thumbColor: Colors.deepPurple.shade50,
                      value: (musicProvider.currentPosition?.inSeconds ?? 0)
                          .toDouble(),
                      max: (musicProvider.totalDuration?.inSeconds ?? 0)
                          .toDouble(),
                      onChanged: (value) {
                        musicProvider
                            .seekMusic(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                  Text(
                      style: TextStyle(fontSize: hi / 60),
                      _formatDuration(
                          musicProvider.totalDuration ?? Duration.zero)),
                ],
              ),
            ),
            space,
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: _playPrevious,
                          icon:
                              const Icon(Icons.skip_previous_rounded, size: 40),
                        ),
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: FloatingActionButton(
                            backgroundColor: Colors.redAccent,
                            onPressed: () {
                              if (musicProvider.isPlaying) {
                                musicProvider.pauseMusic();
                              } else {
                                musicProvider.resumeMusic();
                              }
                            },
                            child: Icon(
                              musicProvider.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _playNext,
                          icon: Icon(Icons.skip_next_rounded, size: hi / 30),
                        ),
                      ],
                    ),

                    // Repeat, Shuffle, Playlist buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              repeatMode = getNextRepeatMode(repeatMode);
                              _setRepeatMode(musicProvider);
                            });
                          },
                          icon: Icon(
                            repeatMode == RepeatMode.off
                                ? Icons.repeat
                                : (repeatMode == RepeatMode.one
                                    ? Icons.repeat_one
                                    : Icons.repeat),
                            color: Colors.white,
                            size: hi / 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isShuffling = !isShuffling;
                              if (isShuffling) {
                                musicProvider.musicFiles.shuffle();
                              }
                            });
                          },
                          icon: Icon(
                            isShuffling
                                ? Icons.shuffle
                                : Icons.shuffle_outlined,
                            color: isShuffling ? Colors.blue : Colors.white,
                            size: hi / 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _showPlaylistDialog(
                                context,
                                Provider.of<PlaylistProvider>(context,
                                    listen: false),
                                musicProvider.currentMusicFile!);
                          },
                          icon: Icon(Icons.playlist_play,
                              color: Colors.white, size: hi / 30),
                        ),
                        IconButton(
                          onPressed: () {
                            musicProvider.toggleFavorite(musicProvider
                                .currentMusicFile!); // Toggle favorite status
                            bool isFavorite = musicProvider.isFavorite(musicProvider
                                .currentMusicFile!); // Check new favorite status
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating, // Makes the SnackBar float above the bottom
                                margin: const EdgeInsets.all(10),
                                backgroundColor: Colors.red,
                                content: Text(
                                  style: TextStyle(fontSize: hi/50),
                                  isFavorite
                                      ? 'Added to Favorites'
                                      : 'Removed from Favorites',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: Icon(
                            musicProvider
                                    .isFavorite(musicProvider.currentMusicFile!)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: musicProvider
                                    .isFavorite(musicProvider.currentMusicFile!)
                                ? Colors.red
                                : Colors.white,
                            size: hi / 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlaylistDialog(BuildContext context,
      PlaylistProvider playlistProvider, MusicFile musicFile) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add to Playlist'),
          content: SizedBox(
            height: 300,
            width: double.maxFinite,
            child: playlistProvider.playlists.isEmpty
                ? const Center(child: Text('No playlists available.'))
                : ListView.builder(
                    itemCount: playlistProvider.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlistProvider.playlists[index];
                      return ListTile(
                        title: Text(playlist.name),
                        trailing: const Icon(Icons.add),
                        onTap: () {
                          playlistProvider.addSongToPlaylist(
                              playlist, musicFile);
                          Navigator.pop(context); // Close the dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${musicFile.title} added to ${playlist.name}')),
                          );
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showCreatePlaylistDialog(context, playlistProvider,
                    musicFile); // Optionally, create new playlist
              },
              child: const Text('Create New Playlist'),
            ),
          ],
        );
      },
    );
  }

  void _showCreatePlaylistDialog(BuildContext context,
      PlaylistProvider playlistProvider, MusicFile musicFile) {
    final TextEditingController playlistNameController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a New Playlist'),
          content: TextField(
            controller: playlistNameController,
            decoration: const InputDecoration(hintText: 'Enter playlist name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final playlistName = playlistNameController.text.trim();
                if (playlistName.isNotEmpty) {
                  final newPlaylist = Playlist(name: playlistName, songs: []);
                  playlistProvider.createPlaylist(newPlaylist).then((key) {
                    playlistProvider.addSongToPlaylist(newPlaylist, musicFile);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Playlist "$playlistName" created and song added!')),
                    );
                    Navigator.pop(context); // Close the dialog
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid playlist name.')),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _playNext() {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    if (currentIndex < widget.playlist.length - 1) {
      setState(() {
        currentIndex++;
        final nextMusicFile = widget.playlist[currentIndex];
        musicProvider.playMusic(nextMusicFile);
      });
    }
  }

  void _playPrevious() {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        final previousMusicFile = widget.playlist[currentIndex];
        musicProvider.playMusic(previousMusicFile);
      });
    }
  }

  void _setRepeatMode(MusicProvider musicProvider) {
    _onCompleteSubscription?.cancel();
    if (repeatMode == RepeatMode.off) {
      musicProvider.audioPlayer.setReleaseMode(ReleaseMode.stop);
    } else if (repeatMode == RepeatMode.one) {
      musicProvider.audioPlayer.setReleaseMode(ReleaseMode.loop);
    } else if (repeatMode == RepeatMode.all) {
      musicProvider.audioPlayer.setReleaseMode(ReleaseMode.stop);
      _onCompleteSubscription =
          musicProvider.audioPlayer.onPlayerComplete.listen((event) {
        _playNext();
      });
    }
  }

  @override
  void dispose() {
    _onCompleteSubscription?.cancel();
    super.dispose();
  }

  RepeatMode getNextRepeatMode(RepeatMode currentMode) {
    switch (currentMode) {
      case RepeatMode.off:
        return RepeatMode.all;
      case RepeatMode.all:
        return RepeatMode.one;
      case RepeatMode.one:
        return RepeatMode.off;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
