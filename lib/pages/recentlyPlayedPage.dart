import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../musicController/MusicProvider.dart';
import 'detailpage.dart';

class RecentlyPlayedPage extends StatelessWidget {
  const RecentlyPlayedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);
    final hi = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recently Played',
          style: TextStyle(fontSize: hi / 50),
        ),
      ),
      body: musicProvider.recentlyPlayed.isEmpty
          ? const Center(
              child: Text(
                'No recently played songs',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: musicProvider.recentlyPlayed.length,
              itemBuilder: (context, index) {
                final musicFile = musicProvider.recentlyPlayed[index];
                return Card(
                  color: Colors.grey.shade900,
                  child: ListTile(
                    leading: const Icon(Icons.music_note, color: Colors.white),
                    title: Text(
                      musicFile.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: hi / 50, color: Colors.white),
                    ),
                    onTap: () {
                      // Navigate to the DetailPage with the selected song
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            musicFile: musicFile, // Pass the selected song
                            playlist: musicProvider
                                .recentlyPlayed, // Pass the recently played list as the playlist
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
