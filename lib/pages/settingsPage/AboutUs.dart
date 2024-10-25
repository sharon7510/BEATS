import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String appName = "BEATS";
    String developerName = "Sharon Antony";
    String gmail = "samdevworks100@gmail.com";
    final hi = MediaQuery.of(context).size.height;
    // final wi = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: TextStyle(fontSize: hi/50),
            'About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About $appName',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  style: TextStyle(fontSize: hi/50),
                  '$appName is designed to provide a seamless music experience. With features like customizable playlists, dark mode, and real-time song recommendations, $appName  is your go-to app for all your music needs.',
                ),
                const SizedBox(height: 20),
                Text(
                  'Purpose:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  style: TextStyle(fontSize: hi/50),
                  'Our goal is to deliver an intuitive and enjoyable music experience. Whether you are creating playlists or discovering new music, $appName  offers the tools to enhance your listening habits.',
                ),
                const SizedBox(height: 20),
                Text(
                  'Features:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  style: TextStyle(fontSize: hi/50),
                  '- Customizable playlists: Create and manage playlists with ease.\n'
                      // '- Dark mode: Toggle between light and dark themes for a comfortable user experience.\n'
                      '- Offline access: Enjoy your music even without an internet connection.\n'
                      // '- Song recommendations: Get suggestions based on your music preferences.\n'
                      '- Favorite songs: Mark songs as favorites for quick access.',
                ),
                const SizedBox(height: 20),
                Text(
                  'Technologies Used:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  style: TextStyle(fontSize: hi/50),
                  '- Flutter: The app is built using Flutter for a fast and cross-platform experience.\n'
                      '- Hive: For secure and fast local storage of music playlists and user preferences.\n'
                      '- Provider: State management using the Provider package for efficient app state control.',
                ),
                const SizedBox(height: 20),
                Text(
                  'Version:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  '1.0.0',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: hi/50),
                ),
                const SizedBox(height: 20),
                Text(
                  'Developer:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  style: TextStyle(fontSize: hi/50),
                  developerName,
                ),
                const SizedBox(height: 20),
                Text(
                  'Contact Us:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                    style: TextStyle(fontSize: hi/50),
                  'For support or inquiries, contact us at:\n'
                      'Email: $gmail\n'
                      // 'Website: www.yourcompany.com\n',
                ),
                const SizedBox(height: 20),
                Text(
                  'Credits:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  style: TextStyle(fontSize: hi/50),
                  '- Icons provided by Flutter.\n'
                      // '- Music API provided by [API Provider Name].\n'
                      '- Special thanks to all the developers who contributed to open-source libraries used in this app.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
