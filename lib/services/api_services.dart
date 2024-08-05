// ignore_for_file: prefer_const_declarations, avoid_print

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Map<String, dynamic>>> fetchBlogs() async {
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret = dotenv.env["adminSecret"]!;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        var res = json.decode(response.body)['blogs'];
        return List<Map<String, dynamic>>.from(res);
      } else {}
    } catch (e) {
      print(e);
      return [];
    }
    return [];
  }
}
