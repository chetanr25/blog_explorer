// ignore_for_file: non_constant_identifier_names

class Blog {
  final int id;
  final String title;
  final String image_url;

  Blog({required this.id, required this.title, required this.image_url});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      image_url: json['image_url'],
      title: json['title'],
    );
  }
}
