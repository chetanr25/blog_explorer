import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/screens/details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomImageCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String id;
  CustomImageCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.id});

  @override
  State<CustomImageCard> createState() => _CustomImageCardState();
}

class _CustomImageCardState extends State<CustomImageCard> {
  SharedPreferences? prefs;

  List<String> favoriteBlogs = [];

  // void getPreferences() async {
  //   prefs = await SharedPreferences.getInstance();
  //   // setState(() {
  //   favoriteBlogs = prefs?.getStringList('favoriteBlogs') ?? [];
  //   print(favoriteBlogs.toString());
  //   setState(() {
  //     loaded = true;
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getPreferences();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return DetailsScreen(
            image_url: widget.imageUrl,
            title: widget.title,
            id: widget.id,
            // isFavorite: favoriteBlogs.contains(widget.id),
          );
        }));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              // Icon(
              //   favoriteBlogs.contains(title)
              //       ? Icons.favorite
              //       : Icons.favorite_border,
              //   color: Colors.red,
              //   size: 30,
              // ),
              // Image.network(
              //   imageUrl,
              //   // width: double.infinity,
              //   height: 300,
              //   fit: BoxFit.cover,
              // ),
              Hero(
                tag: widget.id,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                  imageUrl: widget.imageUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Container(
                width: double.infinity,
                color: const Color.fromARGB(137, 98, 98, 98),
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
