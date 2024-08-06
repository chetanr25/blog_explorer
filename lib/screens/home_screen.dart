import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/services/api_services.dart';
import 'package:flutter_blog_explorer/widgets/image_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> blogs = [];
  SharedPreferences? prefs;
  List<String> favoriteBlogs = [];

  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteBlogs = (prefs?.getString('favoriteBlogs') ?? []) as List<String>;
    });
  }

  void fetchBlogs() async {
    blogs = await _apiService.fetchBlogs(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchBlogs();
    getPreferences();
    // blogs = _apiService.fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 45,
        ),
        // actions: [
        //   IconButton(
        //     style: ButtonStyle(
        //       backgroundColor: MaterialStateProperty.all<Color?>(Colors.white),
        //     ),
        //     onPressed: () {
        //       Scaffold.of(context).openEndDrawer();
        //     },
        //     icon: const Icon(
        //       Icons.menu, // Custom icon for the drawer button
        //       color: Colors.black,
        //       size: 30,
        //     ),
        //   ),
        // ],
      ),
      */
      body: StreamBuilder(
        stream: _apiService.fetchBlogs(context).asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
                  child: CustomImageCard(
                    imageUrl: snapshot.data[index]['image_url'],
                    title: snapshot.data[index]['title'],
                    id: snapshot.data[index]['id'],
                  ),
                );
              },
            );
          }
        },
      ),
/*
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Image.asset(
                'assets/images/logo.png',
                height: 45,
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushNamed('/');
              },
            ),
            ListTile(
              title: const Text('Favorites'),
              onTap: () {
                Navigator.of(context).pushNamed('/favorites');
              },
            ),
          ],
        ),
      ),
    */
    );
  }
}
