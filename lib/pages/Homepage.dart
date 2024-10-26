import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/thems.dart';
import '../musicController/MusicProvider.dart';
import '../musicController/modelClass/modelclass.dart';
import '../musicController/playListProvider.dart';
import 'detailpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  bool isSearchActive = false;
  FocusNode searchFocusNode = FocusNode();
  bool isFabVisible = false;
  bool isSongControlsVisible = false;

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicProvider>().requestStoragePermissionAndFetchFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hi = MediaQuery.of(context).size.height;
    final wi = MediaQuery.of(context).size.width;
    final musicProvider = Provider.of<MusicProvider>(context);
    final filteredMusicFiles = searchQuery.isEmpty
        ? musicProvider.musicFiles
        : musicProvider.musicFiles
            .where((musicFile) => musicFile.title
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: isFabVisible
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  isFabVisible = false;
                  isSongControlsVisible = false;
                  if (musicProvider.isPlaying) {
                    musicProvider.pauseMusic();
                  }
                });
              },
              child: Icon(
                musicProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            )
          : null,
      appBar: AppBar(
        title: Text(
          'BEATS',
          style: TextStyle(fontSize: hi / 45, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(isSearchActive ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearchActive = !isSearchActive;
                if (isSearchActive) {
                  FocusScope.of(context).requestFocus(searchFocusNode);
                } else {
                  FocusScope.of(context).unfocus();
                  searchQuery = '';
                  searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          if (isSearchActive)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 80.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  focusNode: searchFocusNode,
                  controller: searchController,
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  onSubmitted: (query) {
                    setState(() {
                      isSearchActive = false;
                      FocusScope.of(context).unfocus();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search music files...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          SizedBox(height: isSongControlsVisible ? 10 : 0),
          Padding(
            padding: const EdgeInsets.all(0.8),
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              duration: const Duration(seconds: 1),
              height: isSongControlsVisible ? hi / 5 : 0.0,
              width: wi,
              padding: const EdgeInsets.all(16.0),
              child: isSongControlsVisible
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  playlist: filteredMusicFiles,
                                  musicFile: musicProvider.currentMusicFile!, // Pass the music file info
                                ),
                              ),
                            );
                          },
                            child: AlbumArtWidget()), // Placeholder for Album Art
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: hi / 6.5,
                                width: wi / 1.9,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: hi / 100, right: hi / 100),
                                      child: Text(
                                        musicProvider.currentMusicFile?.title ??
                                            "Unknown Song",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: hi / 55),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Slider(
                                      value: musicProvider
                                          .currentPosition.inSeconds
                                          .toDouble(),
                                      min: 0.0,
                                      max: musicProvider.totalDuration.inSeconds
                                          .toDouble(),
                                      onChanged: (value) {
                                        musicProvider.seekMusic(
                                            Duration(seconds: value.toInt()));
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              musicProvider.playPrevious(),
                                          child: const Icon(Icons.skip_previous,
                                              color: Colors.white),
                                        ),
                                        Card(
                                          color: Colors.red,
                                          child: Padding(
                                            padding: EdgeInsets.all(hi / 150),
                                            child: InkWell(
                                              onTap: () {
                                                if (musicProvider.isPlaying) {
                                                  musicProvider.pauseMusic();
                                                } else {
                                                  musicProvider.resumeMusic();
                                                }
                                              },
                                              child: Icon(
                                                  size: hi / 30,
                                                  !musicProvider.isPlaying
                                                      ? Icons.play_arrow
                                                      : Icons.pause),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => musicProvider.playNext(),
                                          child: const Icon(Icons.skip_next,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
          ),
          Expanded(
            child: musicProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  ) // Show loading spinner
                : filteredMusicFiles.isEmpty && searchQuery.isNotEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Sorry, no matching songs!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                      )
                    : filteredMusicFiles.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextButton(
                                child: const Text('Retry'),
                                onPressed: () => context
                                    .read<MusicProvider>()
                                    .requestStoragePermissionAndFetchFiles(),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredMusicFiles.length,
                            itemBuilder: (context, index) {
                              final musicFile = filteredMusicFiles[index];
                              bool isFavorite =
                                  musicProvider.isFavorite(musicFile);
                              return Card(
                                color: Colors.grey.shade900,
                                child: ListTile(
                                  leading: const Icon(Icons.music_note,
                                      color: Colors.white),
                                  title: Text(
                                    musicFile.title,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: hi / 55),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      musicProvider.playMusic(musicFile);
                                      isFabVisible = true;
                                      isSongControlsVisible = true;
                                    });
                                  },
                                  onLongPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          musicFile: musicFile,
                                          playlist: filteredMusicFiles,
                                        ),
                                      ),
                                    );
                                  },
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.playlist_add,
                                            color: Colors.white),
                                        onPressed: () {
                                          _showPlaylistDialog(
                                              context,
                                              Provider.of<PlaylistProvider>(
                                                  context,
                                                  listen: false),
                                              musicFile);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          musicProvider
                                              .toggleFavorite(musicFile);
                                          bool updatedFavoriteStatus =
                                              musicProvider
                                                  .isFavorite(musicFile);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              // Makes the SnackBar float above the bottom
                                              margin: const EdgeInsets.all(10),
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: hi / 50),
                                                updatedFavoriteStatus
                                                    ? 'Added to Favorites'
                                                    : 'Removed from Favorites',
                                              ),
                                              duration:
                                                  const Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

void _showPlaylistDialog(BuildContext context,
    PlaylistProvider playlistProvider, MusicFile musicFile) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add to Playlist'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: playlistProvider.playlists.isEmpty
              ? const Center(child: Text('No playlists available.'))
              : ListView.builder(
                  itemCount: playlistProvider.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlistProvider.playlists[index];
                    return Card(
                      color: Colors.grey.shade900,
                      child: ListTile(
                        trailing: const Icon(Icons.add),
                        title: Text(playlist.name),
                        onTap: () {
                          // Add the selected song to the chosen playlist
                          playlistProvider.addSongToPlaylist(
                              playlist, musicFile);
                          Navigator.pop(context); // Close the dialog
                          // Show confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${musicFile.title} added to ${playlist.name}'),
                            ),
                          );
                        },
                      ),
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
                  musicFile); // Show dialog to create a new playlist
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
  final TextEditingController playlistNameController = TextEditingController();

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
