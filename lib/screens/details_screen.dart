// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/screens/favorite_screen.dart';
import 'package:flutter_blog_explorer/utils/toggle_favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  final String image_url;
  final String title;
  final String id;
  // bool isFavorite;
  DetailsScreen({
    super.key,
    required this.image_url,
    required this.title,
    required this.id,
    // required this.isFavorite,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<String> favoriteBlogs = [];
  SharedPreferences? prefs;
  bool favorite = false;

  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // setState(() {
    favoriteBlogs = prefs?.getStringList('favoriteBlogs') ?? [];
    // print(favoriteBlogs.toString());
    // print(favoriteBlogs.contains(widget.id));
    setState(() {
      favorite = favoriteBlogs.contains(widget.id);
    });
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                favorite = !favorite;
                // widget.isFavorite = !widget.isFavorite;
              });
              ToggleFavorite().toggle(widget.id);
            },
            icon: favorite
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 30,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 30,
                  ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: widget.id,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
              imageUrl: widget.image_url,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          // Image.network(
          //   widget.image_url,
          //   height: 300,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'ID: ${widget.id}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.blue,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              onPressed: () {
                var url = Uri.parse(
                    'https://www.google.com/search?q=${widget.title}');
                print(url);
                launchUrl(url, mode: LaunchMode.externalApplication);
              },
              child: const Text('Search on Google'),
            ),
          ),
        ],
      ),
    );
  }
}
