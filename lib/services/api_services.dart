// ignore_for_file: prefer_const_declarations, avoid_print, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/utils/custom_snackbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';

Future<void> copyDatabaseFromAssets() async {
  String databasesPath = await getDatabasesPath();
  String dbPath = path.join(databasesPath, 'blog_database.db');
  bool exists = await databaseExists(dbPath);

  if (!exists) {
    try {
      await Directory(path.dirname(dbPath)).create(recursive: true);
    } catch (_) {
      print('Error creating directory');
    }
    ByteData data = await rootBundle.load('assets/database/blog_database.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes, flush: true);
  }
}

void createDatabase(res) async {
  await copyDatabaseFromAssets();
  String databasesPath = await getDatabasesPath();
  Database database = await openDatabase(
    path.join(databasesPath, 'blog_database.db'),
    version: 1,
  );
  await database.execute('DROP TABLE blogs_database');
  await database.execute(
    'CREATE TABLE blogs_database(id TEXT PRIMARY KEY, title TEXT, image_url TEXT)',
  );
  for (var blog in res) {
    await database.execute(
      'INSERT INTO blogs_database(id, title, image_url) VALUES(?, ?, ?)',
      [blog['id'], blog['title'], blog['image_url']],
    );
  }
  await database.close();
}

class ApiService {
  Future<List<Map<String, dynamic>>> fetchBlogs(BuildContext context) async {
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret = dotenv.env["adminSecret"]!;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        var res = json.decode(response.body)['blogs'];
        createDatabase(res);

        return List<Map<String, dynamic>>.from(res);
      } else {
        CustomSnackbar.snack(context,
            'Something went wrong:\nCouldn\'t get news for you\n(Status code: ${response.statusCode})',
            color: Colors.red);
      }
    } catch (e) {
      // Device is offline bro
      CustomSnackbar.snack(context,
          'The device is currently offline. \nFetching stored responses.');
      String databasesPath = await getDatabasesPath();
      Database database = await openDatabase(
        path.join(databasesPath, 'blog_database.db'),
      );
      List<Map<String, dynamic>> results =
          await database.query('blogs_database');
      return results;
    }
    return [];
  }
}
