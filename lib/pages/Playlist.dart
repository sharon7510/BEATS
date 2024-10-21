import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../const/thems.dart';
import '../musicController/MusicProvider.dart';
import '../musicController/playListProvider.dart';
import '../musicController/modelClass/modelclass.dart';
import 'detailPage.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hi = MediaQuery.of(context).size.height;
    final wi = MediaQuery.of(context).size.width;
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: FloatingActionButton.extended(
          label: Text(
            "Add Your PlayList",
            style: TextStyle(color: Colors.white,fontSize: hi/60),
          ),
          onPressed: () {
            _showCreatePlaylistDialog(
                context, playlistProvider, musicProvider, null);
            // Create a new playlist
          },
        ),
      ),
      appBar: AppBar(
        title: Text('Your Playlists',style: TextStyle(fontSize: hi/45),),
      ),
      body: playlistProvider.playlists.isEmpty
          ? const Center(
              child: Text(
                'No playlists available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: hi/1000,
                ),
                itemCount: playlistProvider.playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlistProvider.playlists[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlaylistDetailScreen(playlist: playlist),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GridTile(
                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                AlbumArtWidget(),
                          ),
                          footer: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Song details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        playlist.name.toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        // Handle overflow
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: hi/60,
                                        ),
                                      ),
                                      Text(
                                        '${playlist.songs.length} songs'
                                            .toUpperCase(),
                                        style:
                                            TextStyle(color: Colors.grey,fontSize: hi/70),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap:  (){
                                    _showEditPlaylistNameDialog(context, playlistProvider, playlist);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple[400],
                                      borderRadius: const BorderRadius.all(Radius.circular(2))
                                    ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Icon(
                                          Icons.edit,
                                          size: hi/50,
                                          color: Colors.white,
                                        ),
                                      )
                                  ),
                                ),
                                // Delete button
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    playlistProvider.deletePlaylist(playlist);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          behavior: SnackBarBehavior.floating, // Makes the SnackBar float above the bottom
                                          margin: const EdgeInsets.all(10),
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            style: TextStyle(fontSize: hi/50),
                                              'Deleted ${playlist.name}')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          child: const Card()),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _showEditPlaylistNameDialog(BuildContext context, PlaylistProvider playlistProvider, Playlist playlist) {
    final TextEditingController playlistNameController = TextEditingController(text: playlist.name);
    final hi = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Playlist Name', style: TextStyle(fontSize: hi / 50)),
          content: TextField(
            controller: playlistNameController,
            decoration: const InputDecoration(hintText: 'Enter new playlist name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(fontSize: hi / 50)),
            ),
            ElevatedButton(
              onPressed: () {
                if (playlistNameController.text.isNotEmpty) {
                  playlist.name = playlistNameController.text;
                  playlist.save(); // Save the updated name to Hive
                  playlistProvider.notifyListeners(); // Notify the listeners to refresh the UI

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating, // Makes the SnackBar float above the bottom
                      margin: const EdgeInsets.all(10),
                      backgroundColor: Colors.red,
                      content: Text(
                        'Playlist name updated to "${playlistNameController.text}"',
                        style: TextStyle(fontSize: hi / 50),
                      ),
                    ),
                  );

                  Navigator.pop(context); // Close the dialog
                }
              },
              child: Text('Save', style: TextStyle(fontSize: hi / 50)),
            ),
          ],
        );
      },
    );
  }



  void _showCreatePlaylistDialog(
      BuildContext context,
      PlaylistProvider playlistProvider,
      MusicProvider musicProvider,
      Playlist? playlist // Optional playlist parameter
      ) {
    final hi = MediaQuery.of(context).size.height;
    final wi = MediaQuery.of(context).size.width;
    final TextEditingController playlistNameController = TextEditingController(
      text: playlist != null
          ? playlist.name
          : '',
    );
    playlistProvider.clearSelectedSongs();
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<PlaylistProvider>(
          builder: (context, playlistProvider, child) {
            return AlertDialog(
              title: Text(
                style: TextStyle(fontSize: hi/50),
                  playlist != null ? 'Edit Playlist' : 'Create New Playlist'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: playlistNameController,
                      decoration:
                          const InputDecoration(hintText: 'Enter playlist name'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Select Songs',
                      style: TextStyle(color: Colors.deepPurpleAccent,fontSize: hi/50),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 300,
                      child: ListView.builder(
                        itemCount: musicProvider.musicFiles.length,
                        itemBuilder: (context, index) {
                          final musicFile = musicProvider.musicFiles[index];
                          final isSelected = playlistProvider.selectedSongs
                              .contains(musicFile);

                          return ListTile(
                            title: Text(
                              style: TextStyle(fontSize: hi/50),
                              musicFile.title,
                              maxLines: 1,
                            ),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (bool? value) {
                                playlistProvider.toggleSongSelection(musicFile);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                      style: TextStyle(fontSize: hi/50),
                      'Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (playlistNameController.text.isNotEmpty &&
                        playlistProvider.selectedSongs.isNotEmpty) {
                      if (playlist == null) {
                        final newPlaylist = Playlist(
                            name: playlistNameController.text, songs: []);
                        final key = await playlistProvider
                            .createPlaylist(newPlaylist); // Get key
                        var playlistsBox = Hive.box<Playlist>('playlistsBox');
                        final createdPlaylist = playlistsBox
                            .get(key); // Fetch created playlist using key

                        if (createdPlaylist != null) {
                          for (var song in playlistProvider.selectedSongs) {
                            playlistProvider.addSongToPlaylist(
                                createdPlaylist, song);
                          }
                          print('Playlist Created: ${createdPlaylist.name}, with ${createdPlaylist.songs.length} songs.');
                        }
                      } else {
                        // Editing existing playlist
                        playlist.name = playlistNameController.text;
                        playlist.songs = playlistProvider.selectedSongs;
                        playlist.save(); // Save changes to Hive
                      }
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            behavior: SnackBarBehavior.floating, // Makes the SnackBar float above the bottom
                            margin: const EdgeInsets.all(10),
                            backgroundColor: Colors.red,
                            content:
                            Text(
                              style: TextStyle(fontSize: hi/50),
                                'Playlist "${playlistNameController.text}" updated with ${playlistProvider.selectedSongs.length} songs')),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                style: TextStyle(fontSize: hi/50),
                                'Please enter a name and select songs for the playlist'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                      style: TextStyle(fontSize: hi/50),
                                      "ok"))
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                      style: TextStyle(fontSize: hi/50),
                      playlist != null ? 'Update' : 'Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class PlaylistDetailScreen extends StatelessWidget {
  final Playlist playlist;

  const PlaylistDetailScreen({required this.playlist});

  @override
  Widget build(BuildContext context) {
    final hi = MediaQuery.of(context).size.height;
    final wi = MediaQuery.of(context).size.width;
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "Add Music",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          _showAddSongsToPlaylistDialog(context, playlistProvider, playlist);
        },
      ),
      appBar: AppBar(
        title: Text(playlist.name),
      ),
      body: playlist.songs.isEmpty
          ? const Center(
              child: Text(
                'No songs in this playlist.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: playlist.songs.length,
              itemBuilder: (context, index) {
                final song = playlist.songs[index];

                return Card(
                  color: Colors.grey.shade900,
                  child: ListTile(
                    leading: const Icon(Icons.music_note),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            musicFile: song,
                            playlist: playlist.songs,
                          ),
                        ),
                      );
                    },
                    title: Text(
                      song.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        playlistProvider.removeSongFromPlaylist(playlist, song);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            padding: const EdgeInsets.all(8),
                            backgroundColor: Colors.red,
                            shape: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  style: TextStyle(
                                    fontSize: hi/50,
                                      color: Colors.white),
                                  maxLines: 1,
                                  'Removed ${song.title} from ${playlist.name}'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

void _showAddSongsToPlaylistDialog(BuildContext context,
    PlaylistProvider playlistProvider, Playlist playlist) {
  final hi = MediaQuery.of(context).size.height;
  final wi = MediaQuery.of(context).size.width;
  final musicProvider = Provider.of<MusicProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              style: TextStyle(fontSize: hi/50),
                'Add Songs to ${playlist.name}'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300, // Height to fit the song list
              child: ListView.builder(
                itemCount: musicProvider.musicFiles.length,
                itemBuilder: (context, index) {
                  final musicFile = musicProvider.musicFiles[index];
                  final isSelected = playlist.songs.contains(
                      musicFile); // Check if song is already in the playlist

                  return ListTile(
                    title: Text(
                      style: TextStyle(fontSize: hi/50),
                        musicFile.title),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            playlistProvider.addSongToPlaylist(playlist, musicFile);
                          } else {
                            playlistProvider.removeSongFromPlaylist(playlist,musicFile);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  style: TextStyle(fontSize: hi/50),
                    'Done'),
              ),
            ],
          );
        },
      );
    },
  );
}
