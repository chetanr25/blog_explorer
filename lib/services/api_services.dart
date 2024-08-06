// ignore_for_file: prefer_const_declarations, avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/utils/custom_snackbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';

Future<void> copyDatabaseFromAssets() async {
  String databasesPath = await getDatabasesPath();
  String dbPath = path.join(databasesPath, 'blog_database.db');

  // Check if the database exists
  bool exists = await databaseExists(dbPath);

  if (!exists) {
    // Make sure the parent directory exists
    try {
      await Directory(path.dirname(dbPath)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load('assets/database/blog_database.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(dbPath).writeAsBytes(bytes, flush: true);
  }
}

Future<Database> openMyDatabase() async {
  final dbPath = await getDatabasesPath();
  final path1 = path.join(dbPath, 'blog_database.db');
  final database = await openDatabase(
    path1,
    version: 1,
    onCreate: (db, version) async {
      // Create tables here
    },
  );
  return database;
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
        // String databasesPath = await getDatabasesPath();
        // print(databasesPath);
        // final db = await openMyDatabase();
        // db.batch().insert(
        //   'my_table',
        //   [
        //     {'column1': 'value1', 'column2': 42},
        //     {'column1': 'value2', 'column2': 43},
        //     {'column1': 'value3', 'column2': 44},
        //   ],
        // );
        // return;
        await copyDatabaseFromAssets();
        String databasesPath = await getDatabasesPath();
        Database database = await openDatabase(
          path.join(databasesPath, 'blog_database.db'),
          // 'assets/database/blog_database.db',
          // path.join(databasesPath, 'blog_database.db'),
          version: 1,
          // path.join(await getDatabasesPath(), 'blog_database.db'),
          onCreate: (db, version) async {
            print('Creating database');
            await db.execute(
              'CREATE TABLE blogs_database(id INTEGER PRIMARY KEY, title TEXT, image_url TEXT)',
            );
          },
          onUpgrade: (db, oldVersion, newVersion) async {
            print('Upgrading database from $oldVersion to $newVersion');
            await db.execute('DROP TABLE blogs_database');
            await db.execute(
              'CREATE TABLE blogs_database(id INTEGER PRIMARY KEY, title TEXT, image_url TEXT)',
            );
            for (var blog in res) {
              print(blog);
              await db.execute(
                'INSERT INTO blogs_database(id, title, image_url) VALUES(${blog['id']}, "${blog['title']}", "${blog['image_url']}")',
              );
            }
            // await db.execute(
            //   'Insert INTO blogs_database(id, title, image_url) VALUES(${res['id']}, ${res['title']}, ${res['image_url']})',
            // );
          },
        );
        await database.execute('DROP TABLE blogs_database');
        await database.execute(
          'CREATE TABLE blogs_database(id TEXT PRIMARY KEY, title TEXT, image_url TEXT)',
        );
        for (var blog in res) {
          print(blog);
          print(blog['id']);
          await database.execute(
            'INSERT INTO blogs_database(id, title, image_url) VALUES(?, ?, ?)',
            [blog['id'], blog['title'], blog['image_url']],
          );
          print('Inserted');
        }
        // print(database);
        // await database.execute('DROP TABLE blogs_database');
        // await database.execute(
        //     'CREATE TABLE IF NOT EXISTS blogs_database(id INTEGER PRIMARY KEY, title TEXT, image_url TEXT)');
        // await database.execute(
        //     'CREATE TABLE blogs_database(id INTEGER PRIMARY KEY, title TEXT, image_url TEXT)');
        // for (var blog in res) {
        //   print(blog['id']);
        //   await database.execute(
        //     'INSERT INTO blogs_database(id, title, image_url) VALUES(${blog['id']}, "${blog['title']}", "${blog['image_url']}")',
        // );

        // await database.insert(
        //   'blogs',
        //   {
        //     'id': blog['id'],
        //     'title': blog['title'],
        //     'image_url': blog['image_url'],
        //   },
        //   conflictAlgorithm: ConflictAlgorithm.replace,
        // );
        // }
        await database.close();

        return List<Map<String, dynamic>>.from(res);
      } else {
        print(response.statusCode);
        print('Failed to load blogs');
        String databasesPath = await getDatabasesPath();
        Database database = await openDatabase(
          path.join(databasesPath, 'blog_database.db'),
        );
        var x = database.execute('SELECT * FROM blogs_database');
        print(x);
        // print('Failed to load blogs');
        CustomSnackbar.snack(context, 'Failed to load blogs');
      }
    } catch (e) {
      print('Failed to load blogs');
      // print(e);
      // return [];
      String databasesPath = await getDatabasesPath();
      Database database = await openDatabase(
        path.join(databasesPath, 'blog_database.db'),
      );
      print(database);
      List<Map<String, dynamic>> results =
          await database.query('blogs_database');
      // for (var row in results) {
      //   // print(row.toString());
      // }
      return results;
      var x = await database.execute('SELECT * FROM blogs_database');
      // print(x.toString());
      print('Failed to load blogs');
      CustomSnackbar.snack(context, 'Failed to load blogs');
      print(e);
      return [
        {
          'id': 1,
          'title': 'Error',
          'image_url': 'https://via.placeholder.com/150',
        }
      ];
    }
    return [];
  }
}

// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:path/path.dart' as path;
// import 'package:sqflite/sqflite.dart';
// import 'dart:io';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// Future<void> copyDatabaseFromAssets() async {
//   String databasesPath = await getDatabasesPath();
//   String dbPath = path.join(databasesPath, 'blog_database.db');

//   // Check if the database exists
//   bool exists = await databaseExists(dbPath);

//   if (!exists) {
//     // Make sure the parent directory exists
//     try {
//       await Directory(path.dirname(dbPath)).create(recursive: true);
//     } catch (_) {}

//     // Copy from asset
//     ByteData data = await rootBundle.load('assets/database/blog_database.db');
//     List<int> bytes =
//         data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

//     // Write and the bytes written
//     await File(dbPath).writeAsBytes(bytes, flush: true);
//   }
// }

// class ApiService {
//   Future<List<Map<String, dynamic>>> fetchBlogs(BuildContext context) async {
//     try {
//       final response = await http.get(
//           Uri.parse('https://intent-kit-16.hasura.app/api/rest/blogs'),
//           headers: {
//             'x-hasura-admin-secret': dotenv.env["adminSecret"]!,
//           });

//       if (response.statusCode == 200) {
//         var res = json.decode(response.body)['blogs'];

//         await copyDatabaseFromAssets();
//         String databasesPath = await getDatabasesPath();
//         Database database = await openDatabase(
//           path.join(databasesPath, 'blog_database.db'),
//           version: 1,
          
//         );
//         return List<Map<String, dynamic>>.from(res);
//         // Your database operations here
//       }
//     } catch (e) {
//       print(e);
//     }
//     return [];
//   }
// }
