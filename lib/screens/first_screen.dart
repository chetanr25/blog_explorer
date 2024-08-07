import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/screens/favorite_screen.dart';
import 'package:flutter_blog_explorer/screens/feedback.dart';
import 'package:flutter_blog_explorer/screens/home_screen.dart';
import 'package:flutter_blog_explorer/services/api_services.dart';
import 'package:flutter_blog_explorer/widgets/image_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FirstScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> blogs = [];
  SharedPreferences? prefs;
  List<String> favoriteBlogs = [];
  List<Widget> screens = [
    const HomeScreen(),
    const FavoriteScreen(),
    const FeedbackScreen()
  ];
  int currentScreen = 0;

  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   favoriteBlogs = (prefs?.getString('favoriteBlogs') ?? []) as List<String>;
    // });
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 45,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ],
      ),
      body: screens[currentScreen],
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(129, 47, 46, 46),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                height: 45,
              ),
            ),
            ListTile(
              tileColor: currentScreen == 0
                  ? const Color.fromARGB(255, 73, 73, 73)
                  : null,
              title: const Text(
                'Home',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                setState(() {
                  currentScreen = 0;
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text(
                'Favorites',
                style: TextStyle(fontSize: 18),
              ),
              tileColor: currentScreen == 1
                  ? const Color.fromARGB(255, 73, 73, 73)
                  : null,
              onTap: () {
                setState(() {
                  currentScreen = 1;
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              tileColor: currentScreen == 2
                  ? const Color.fromARGB(255, 73, 73, 73)
                  : null,
              title: const Text(
                'Feedback',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                setState(() {
                  currentScreen = 2;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
