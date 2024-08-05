import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  const CustomImageCard(
      {super.key, required this.imageUrl, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
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
            // Image.network(
            //   imageUrl,
            //   // width: double.infinity,
            //   height: 300,
            //   fit: BoxFit.cover,
            // ),
            CachedNetworkImage(
              fit: BoxFit.cover,
              height: 300,
              imageUrl: imageUrl,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Container(
              width: double.infinity,
              color: const Color.fromARGB(137, 98, 98, 98),
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
