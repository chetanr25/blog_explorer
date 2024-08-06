import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/services/api_services.dart';
import 'package:flutter_blog_explorer/widgets/image_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> blogs = [];

  void fetchBlogs() async {
    blogs = await _apiService.fetchBlogs(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchBlogs();
    // blogs = _apiService.fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/logo.png',
            height: 45,
          ),
        ),
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
                    padding:
                        const EdgeInsets.only(top: 15, left: 16, right: 16),
                    child: CustomImageCard(
                        imageUrl: snapshot.data[index]['image_url'],
                        title: snapshot.data[index]['title']),
                  );
                },
              );
            }
          },
        ));
  }
}
