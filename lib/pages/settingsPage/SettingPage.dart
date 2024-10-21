import 'package:beats/pages/settingsPage/privacypolicypage.dart';
import 'package:flutter/material.dart';
import '../recentlyPlayedPage.dart';
import 'AboutUs.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // final wi = MediaQuery.of(context).size.width;
    final hi = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',style: TextStyle(fontSize: hi/45),),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap:  (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecentlyPlayedPage()),
              );
            },
            leading: const Icon(Icons.history),
            title: Text(
                style: TextStyle(fontSize: hi/50),
                "Watch History"),
            subtitle: Text(
                style: TextStyle(fontSize: hi/50),
                'Recently Played'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(
                style: TextStyle(fontSize: hi/50),
                'About'),
            subtitle: Text(
                style: TextStyle(fontSize: hi/50),
                'Learn more about the app'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(
                style: TextStyle(fontSize: hi/50),
                'Privacy Policy'),
            subtitle: Text(
                style: TextStyle(fontSize: hi/50),
                'Read our privacy policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicyPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
