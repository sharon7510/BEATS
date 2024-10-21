import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../musicController/uiProvider.dart';
import 'FavoritePage.dart';
import 'Homepage.dart';
import 'Playlist.dart';
import 'settingsPage/SettingPage.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<Widget> _pages = [
    SettingsPage(),
    const HomePage(),
    const FavoritesPage(),
    PlaylistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final hi = MediaQuery.of(context).size.height;
    final wi = MediaQuery.of(context).size.width;
    final tabProvider = Provider.of<TabProvider>(context);

    return Scaffold(
      body: _pages[tabProvider.currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: tabProvider.currentIndex,
        height: 60.0,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          tabProvider.onTabTapped(index, context);
        },
        items: <Widget>[
          Icon(Icons.settings, size: hi/30, color: Colors.white),
          Icon(Icons.home, size: hi/30, color: Colors.white), // Home tab
          Icon(Icons.favorite, size: hi/30, color: Colors.white),
          Icon(Icons.playlist_play, size: hi/30, color: Colors.white),
        ],
      ),
    );
  }
}
