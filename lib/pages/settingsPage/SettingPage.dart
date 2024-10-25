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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Settings',style: TextStyle(fontSize: hi/45,color: Colors.white),),
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
            leading: const Icon(Icons.history,color: Colors.white),
            title: Text(
                style: TextStyle(fontSize: hi/50,color: Colors.white),
                "Watch History"),
            subtitle: Text(
                style: TextStyle(fontSize: hi/50,color: Colors.white),
                'Recently Played'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info,color: Colors.white),
            title: Text(
                style: TextStyle(fontSize: hi/50,color: Colors.white),
                'About'),
            subtitle: Text(
                style: TextStyle(fontSize: hi/50,color: Colors.white),
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
            leading: const Icon(Icons.privacy_tip,color: Colors.white),
            title: Text(
                style: TextStyle(fontSize: hi/50,color: Colors.white),
                'Privacy Policy'),
            subtitle: Text(
                style: TextStyle(fontSize: hi/50,color: Colors.white),
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
