import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'modelClass/modelclass.dart';

class PlaylistProvider with ChangeNotifier {
  List<Playlist> _playlists = [];
  List<MusicFile> _selectedSongs = [];

  List<Playlist> get playlists => _playlists;
  List<MusicFile> get selectedSongs => _selectedSongs;

  PlaylistProvider() {
    _loadPlaylistsFromHive();
  }

  void _loadPlaylistsFromHive() {
    var playlistsBox = Hive.box<Playlist>('playlistsBox');
    _playlists = List<Playlist>.from(playlistsBox.values);
    notifyListeners();
  }


  Future<int> createPlaylist(Playlist newPlaylist) async {
    var playlistsBox = Hive.box<Playlist>('playlistsBox');
    int key = await playlistsBox.add(newPlaylist);
    _playlists.add(newPlaylist);
    notifyListeners();
    return key;
  }


  void toggleSongSelection(MusicFile song) {
    if (_selectedSongs.contains(song)) {
      _selectedSongs.remove(song);
    } else {
      _selectedSongs.add(song);
    }
    notifyListeners();
  }

  // Clear selected songs
  void clearSelectedSongs() {
    _selectedSongs.clear();
    notifyListeners();
  }

  // Add a song to a playlist
  Future<void> addSongToPlaylist(Playlist playlist, MusicFile song) async {
    playlist.songs.add(song);
    await playlist.save();
    notifyListeners();
  }

  // Delete a playlist
  Future<void> deletePlaylist(Playlist playlist) async {
    await playlist.delete();
    _playlists.remove(playlist);
    notifyListeners();
  }

  // Remove a song from a playlist
  Future<void> removeSongFromPlaylist(Playlist playlist, MusicFile song) async {
    playlist.songs.remove(song);
    await playlist.save();
    notifyListeners();
  }
}
