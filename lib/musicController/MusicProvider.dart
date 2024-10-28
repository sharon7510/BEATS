import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'modelClass/modelclass.dart';

MusicProvider musicProvider = MusicProvider();

class MusicProvider with ChangeNotifier {

  Future<void> requestStoragePermissionAndFetchFiles() async {
    _isLoading = true;
    notifyListeners();

    // Check and request storage permission
    if (await _requestStoragePermission()) {
      await fetchAllMusicFiles();  // Fetch music files if permission is granted
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> _requestStoragePermission() async {
    // If storage permission is already granted
    if (await Permission.storage.isGranted) {
      print("Storage permission already granted.");
      return true;
    }

    // Request storage permission for devices below Android 11
    if (await Permission.storage.request().isGranted) {
      print("Storage permission granted.");
      return true;
    }

    // For Android 11+ (API 30+), check for MANAGE_EXTERNAL_STORAGE permission
    if (await Permission.manageExternalStorage.isGranted) {
      print("Manage external storage permission granted.");
      return true;
    }

    // Request MANAGE_EXTERNAL_STORAGE permission for Android 11+ if not granted
    if (await Permission.manageExternalStorage.request().isGranted) {
      print("Manage external storage permission granted after request.");
      return true;
    }

    // If permission is permanently denied, guide user to app settings
    if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      print("Storage permission permanently denied, opening app settings.");
      await openAppSettings();  // Opens the settings for the user to manually grant permission
    }

    print("Permission denied.");
    return false;
  }

  List<MusicFile> _musicFiles = [];
  List<MusicFile> _favorites = [];
  List<Playlist> _playlists = [];
  List<MusicFile> _recentlyPlayed = []; // List to store recently played songs
  bool _isLoading = false;

  AudioPlayer audioPlayer = AudioPlayer();
  MusicFile? _currentMusicFile;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  List<MusicFile> get musicFiles => _musicFiles;
  List<MusicFile> get favorites => _favorites;
  List<Playlist> get playlists => _playlists;
  List<MusicFile> get recentlyPlayed => _recentlyPlayed; // Getter for recently played
  bool get isLoading => _isLoading;
  bool get isPlaying => _isPlaying;
  MusicFile? get currentMusicFile => _currentMusicFile;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;

  MusicProvider() {
    // _loadMusicFilesFromHive();
    _loadFavoritesFromHive();
    _loadPlaylistsFromHive();
    _loadRecentlyPlayedFromHive(); // Load recently played from Hive on startup

    audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      _currentPosition = Duration.zero;
      notifyListeners();
    });
  }

  // Load recently played songs from Hive
  void _loadRecentlyPlayedFromHive() {
    var recentlyPlayedBox = Hive.box('recentlyPlayedBox');
    List<dynamic> storedData = recentlyPlayedBox.get('recentlyPlayed', defaultValue: <MusicFile>[]);

    _recentlyPlayed = storedData.map((data) {
      if (data is String) {
        return MusicFile(path: data, title: data.split('/').last);
      } else if (data is MusicFile) {
        return data;
      }
      throw Exception('Invalid data in Hive: $data');
    }).toList();
    notifyListeners();
  }

  // Save recently played songs to Hive
  void _saveRecentlyPlayedToHive() {
    var recentlyPlayedBox = Hive.box('recentlyPlayedBox');
    recentlyPlayedBox.put('recentlyPlayed', _recentlyPlayed.map((song) => song.path).toList());
  }

  // Load music files from Hive
  Future<void> _loadFavoritesFromHive() async {
    var favoritesBox = Hive.box<String>('favorites');
    List<String> favoritePaths = List<String>.from(favoritesBox.values);

    // Load only those musicFiles that match a path in favoritePaths
    _favorites = _musicFiles.where((musicFile) => favoritePaths.contains(musicFile.path)).toList();

    print("Loaded favorites from Hive: ${_favorites.map((e) => e.title).toList()}"); // Debugging
    notifyListeners();
  }


  // Load favorite songs from Hive
  // void _loadFavoritesFromHive() {
  //   var favoritesBox = Hive.box<String>('favorites');
  //   List<String> favoritePaths = List<String>.from(favoritesBox.values);
  //
  //   _favorites = _musicFiles.where((musicFile) => favoritePaths.contains(musicFile.path)).toList();
  //   notifyListeners();
  // }

  // Load playlists from Hive
  void _loadPlaylistsFromHive() {
    var playlistsBox = Hive.box<Playlist>('playlistsBox');
    _playlists = List<Playlist>.from(playlistsBox.values);
    notifyListeners();
  }

  // Create a new playlist
  Future<void> createPlaylist(String playlistName) async {
    var playlistsBox = Hive.box<Playlist>('playlistsBox');
    var newPlaylist = Playlist(name: playlistName, songs: []);
    await playlistsBox.add(newPlaylist);
    _playlists.add(newPlaylist);
    notifyListeners();
  }

  // Add song to playlist
  Future<void> addSongToPlaylist(Playlist playlist, MusicFile song) async {
    playlist.songs.add(song);
    await playlist.save();
    notifyListeners();
  }

  // Remove song from playlist
  Future<void> removeSongFromPlaylist(Playlist playlist, MusicFile song) async {
    playlist.songs.remove(song);
    await playlist.save();
    notifyListeners();
  }

  // Delete a playlist
  Future<void> deletePlaylist(Playlist playlist) async {
    await playlist.delete();
    _playlists.remove(playlist);
    notifyListeners();
  }
  void toggleFavorite(MusicFile musicFile) {
    var favoritesBox = Hive.box<String>('favorites');

    // Check if the song is in favorites in Hive directly
    if (favoritesBox.containsKey(musicFile.path)) {
      favoritesBox.delete(musicFile.path);
      _favorites.removeWhere((item) => item.path == musicFile.path); // Ensure it's removed from the list
      print("Removed from favorites: ${musicFile.title}");
    } else {
      favoritesBox.put(musicFile.path, musicFile.path);
      _favorites.add(musicFile); // Add to the list as well
      print("Added to favorites: ${musicFile.title}");
    }

    notifyListeners(); // Notify UI of change
  }


  // Future<void> _loadFavoritesFromHive() async {
  //   var favoritesBox = Hive.box<String>('favorites');
  //   List<String> favoritePaths = List<String>.from(favoritesBox.values);
  //
  //   _favorites = _musicFiles.where((musicFile) => favoritePaths.contains(musicFile.path)).toList();
  //   print("Loaded favorites: ${_favorites.map((e) => e.title).toList()}");
  //   notifyListeners();
  // }


  // Toggle favorite status
  // void toggleFavorite(MusicFile musicFile) {
  //   var favoritesBox = Hive.box<String>('favorites');
  //   if (_favorites.contains(musicFile)) {
  //     _favorites.remove(musicFile);
  //     favoritesBox.delete(musicFile.path);
  //   } else {
  //     _favorites.add(musicFile);
  //     favoritesBox.put(musicFile.path, musicFile.path);
  //   }
  //   notifyListeners();
  // }

  bool isFavorite(MusicFile musicFile) {
    var favoritesBox = Hive.box<String>('favorites');
    return favoritesBox.containsKey(musicFile.path); // Directly check Hive
  }


  // bool isFavorite(MusicFile musicFile) {
  //   return _favorites.contains(musicFile);
  // }

  Future<void> fetchAllMusicFiles() async {
    List<MusicFile> audioFiles = [];
    List<Directory> directoriesToSearch = [
      Directory('/storage/emulated/0/Music'),
      Directory('/storage/emulated/0/Download'),
      Directory('/storage/emulated/0/Audio'),
      Directory('/storage/emulated/0/Podcasts'),
      Directory('/storage/emulated/0/Ringtones'),
      Directory('/storage/emulated/0/Alarms'),
      Directory('/storage/emulated/0/Notifications'),
    ];

    try {
      for (Directory dir in directoriesToSearch) {
        if (await dir.exists()) {
          audioFiles.addAll(await _scanDirectoryForAudioFiles(dir));
        }
      }

      _musicFiles = audioFiles;
      var box = Hive.box('musicBox');
      box.put('musicFiles', _musicFiles);

      notifyListeners();
    } catch (e) {
      print("Error fetching music files: $e");
    }
  }

// Recursive function to scan for audio files without dependencies
//   Future<List<MusicFile>> _scanDirectoryForAudioFiles(Directory dir) async {
//     List<MusicFile> audioFiles = [];
//     await for (var entity in dir.list(recursive: true, followLinks: false)) {
//       if (entity is File && (entity.path.endsWith('.mp3') || entity.path.endsWith('.wav') || entity.path.endsWith('.m4a'))) {
//         audioFiles.add(MusicFile(
//           path: entity.path,
//           title: entity.uri.pathSegments.last, // Use the filename as the title
//         ));
//       }
//     }
//     return audioFiles;
//   }


  // Fetch all music files from storage
  // Future<void> fetchAllMusicFiles() async {
  //   List<MusicFile> audioFiles = [];
  //   try {
  //     Directory musicDir = Directory('/storage/emulated/0/Music');
  //     Directory downloadDir = Directory('/storage/emulated/0/Download');
  //
  //     if (await musicDir.exists()) {
  //       audioFiles.addAll(await _scanDirectoryForAudioFiles(musicDir));
  //     }
  //     if (await downloadDir.exists()) {
  //       audioFiles.addAll(await _scanDirectoryForAudioFiles(downloadDir));
  //     }
  //
  //     _musicFiles = audioFiles;
  //     var box = Hive.box('musicBox');
  //     box.put('musicFiles', _musicFiles);
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error fetching music files: $e");
  //   }
  // }

  // Scan a directory for audio files
  Future<List<MusicFile>> _scanDirectoryForAudioFiles(Directory dir) async {
    List<MusicFile> audioFiles = [];
    await for (var entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File && (entity.path.endsWith('.mp3') || entity.path.endsWith('.wav'))) {
        audioFiles.add(MusicFile(path: entity.path, title: entity.path.split('/').last));
      }
    }
    return audioFiles;
  }

  // Play music and add it to recently played
  Future<void> playMusic(MusicFile musicFile) async {
    _currentMusicFile = musicFile;
    await audioPlayer.play(DeviceFileSource(musicFile.path));
    _isPlaying = true;

    // Add to recently played list
    _recentlyPlayed.remove(musicFile); // Remove if already present
    _recentlyPlayed.insert(0, musicFile); // Add to the front

    // Limit the recently played list to the last 10 songs
    if (_recentlyPlayed.length > 10) {
      _recentlyPlayed = _recentlyPlayed.sublist(0, 10);
    }

    _saveRecentlyPlayedToHive(); // Save the recently played list to Hive

    notifyListeners();
  }

  // Pause music
  Future<void> pauseMusic() async {
    await audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume music
  Future<void> resumeMusic() async {
    await audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Seek music position
  Future<void> seekMusic(Duration position) async {
    await audioPlayer.seek(position);
  }

  // Stop music
  Future<void> stopMusic() async {
    await audioPlayer.stop();
    _isPlaying = false;
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  // Play next song
  Future<void> playNext() async {
    if (_currentMusicFile != null) {
      int currentIndex = _musicFiles.indexOf(_currentMusicFile!);
      if (currentIndex < _musicFiles.length - 1) {
        playMusic(_musicFiles[currentIndex + 1]);
      }
    }
  }

  // Play previous song
  Future<void> playPrevious() async {
    if (_currentMusicFile != null) {
      int currentIndex = _musicFiles.indexOf(_currentMusicFile!);
      if (currentIndex > 0) {
        playMusic(_musicFiles[currentIndex - 1]);
      }
    }
  }
}
