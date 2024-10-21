import 'package:beats/pages/BottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'const/thems.dart';
import 'musicController/MusicProvider.dart';
import 'musicController/modelClass/modelclass.dart';
import 'musicController/playListProvider.dart';
import 'musicController/uiProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if(!Hive.isAdapterRegistered(0) && !Hive.isAdapterRegistered(1)){
    Hive.registerAdapter(PlaylistAdapter());
    Hive.registerAdapter(MusicFileAdapter());
  }
  await Hive.openBox('musicBox');
  await Hive.openBox<String>('favorites');
  await Hive.openBox<Playlist>('playlistsBox');
  await Hive.openBox('recentlyPlayedBox');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MusicProvider()),
        ChangeNotifierProvider(create: (context) => TabProvider()),
        ChangeNotifierProvider(create: (context) => PlaylistProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode: themeProvider.themeMode,  // Set the theme mode dynamically
      // theme: ThemeData.light(),  // Light theme
      // darkTheme: ThemeData.dark(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      title: 'Music Player',
      home: CustomBottomNavigationBar(),
    );
  }
}
