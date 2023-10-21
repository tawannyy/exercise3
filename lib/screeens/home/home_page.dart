import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.json));
  List<Album>? _albumList;

  void fetchAlbums() async {
    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/albums');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          _albumList = data.map((item) => Album.fromJson(item)).toList();
        });
      } else {
        print('Failed to fetch albums: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error during API request: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Albums'), // Title in the AppBar
      ),
      body: _albumList == null
          ? Center(child: CircularProgressIndicator())
          :
      //ListView.builder(
      ListView.builder(
        itemCount: _albumList!.length,
        itemBuilder: (context, index) {
          var album = _albumList![index];
          return Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(album.title),
                      SizedBox(height: 4.0), // Add some spacing
                      Row(
                        children: [
                          Chip(
                            label: Text('Album ID: ${album.id}'),
                            backgroundColor: Colors.pink,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 4.0), // Add some spacing
                          Chip(
                            label: Text('User ID: ${album.userId}'),
                            backgroundColor: Colors.blue,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(), // Add a divider line between each album
            ],
          );
        },
      )



      //   itemCount: _albumList!.length,
      //   itemBuilder: (context, index) {
      //     var album = _albumList![index];
      //     return Card(
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Text(album.title),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
