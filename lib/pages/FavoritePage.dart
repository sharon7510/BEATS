import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../musicController/MusicProvider.dart';
import 'detailPage.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hi = MediaQuery.of(context).size.height;
    final wi = MediaQuery.of(context).size.width;
    final musicProvider = Provider.of<MusicProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Favorites',style: TextStyle(fontSize: hi/45,color: Colors.white),),
      ),
      body: musicProvider.favorites.isEmpty
          ? const Center(
              child: Text(
                'No favorite songs yet!',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: musicProvider.favorites.length,
              itemBuilder: (context, index) {
                final favoriteMusicFile = musicProvider.favorites[index];

                return Card(
                  color: Colors.grey.shade900,
                  child: ListTile(
                    leading: const Icon(Icons.music_note,color: Colors.white,),
                    title: Text(
                      style: TextStyle(fontSize: hi/55,color: Colors.white),
                        favoriteMusicFile.title,
                        maxLines: 2),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        musicProvider.toggleFavorite(favoriteMusicFile);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating, // Makes the SnackBar float above the bottom
                            margin: const EdgeInsets.all(10),
                            backgroundColor: Colors.red,
                            content: Text(
                                '${favoriteMusicFile.title} removed from Favorites'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            musicFile: favoriteMusicFile,
                            playlist: musicProvider.favorites,
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
