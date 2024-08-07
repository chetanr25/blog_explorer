import 'package:shared_preferences/shared_preferences.dart';

class ToggleFavorite {
  // final String id;

  // ToggleFavorite(this.id);

  Future<void> toggle(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteBlogs = prefs.getStringList('favoriteBlogs') ?? [];
    if (favoriteBlogs.contains(id)) {
      favoriteBlogs.remove(id);
      print('Removed from favorites' + id);
    } else {
      favoriteBlogs.add(id);
      print('Added to favorites' + id);
    }
    await prefs.setStringList('favoriteBlogs', favoriteBlogs);
    print('Favorites: ' + favoriteBlogs.toString());
  }
}
