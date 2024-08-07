import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/widgets/image_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  SharedPreferences? prefs;
  List<String> favId = [];

  List<Map<String, dynamic>> favData = [];
  void setPreferences() async {
    prefs = await SharedPreferences.getInstance();
    favId = prefs?.getStringList('favoriteBlogs') ?? [];
  }

  void getFav() async {
    String databasesPath = await getDatabasesPath();
    Database database = await openDatabase(
      path.join(databasesPath, 'blog_database.db'),
      version: 1,
    );
    List<Map<String, dynamic>> results = await database.query(
      'blogs_database',
      where: 'id IN (${favId.map((_) => '?').join(',')})',
      whereArgs: favId,
    );
    print(favData);
    setState(() {
      favData = results;
    });
    // database.query('blog_database.db');
  }

  @override
  void initState() {
    super.initState();
    setPreferences();
    getFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Blogs'),
      ),
      body: ListView.builder(
        itemCount: favData.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
            child: CustomImageCard(
              imageUrl: favData[index]['image_url'],
              title: favData[index]['title'],
              id: favData[index]['id'],
            ),
            // );
            // },
          );
        },
      ),
    );
  }
}
