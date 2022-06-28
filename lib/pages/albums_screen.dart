import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/models/albums.dart';

List<Albums> albums = [];

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({Key? key}) : super(key: key);

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  late Future<List<Albums>> fetchAlbums;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAlbums = _fetchAllAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums'),
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Albums>>(
          future: fetchAlbums,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(
                                      (math.Random().nextDouble() * 0xFFFFFF)
                                          .toInt())
                                  .withOpacity(1.0),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                '${data[index].title}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

//fetch all albums from the api

Future<List<Albums>> _fetchAllAlbums() async {
  if (albums.isEmpty) {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/albums');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      //using compute to schedule tasks that take more than a few milliseconds.
      albums = await compute(_parseAlbums, response.body);
    } else {
      throw Exception('Something went wrong.');
    }
  }
  return albums;
}

//idealy a long resource consuming task.

List<Albums> _parseAlbums(String response) {
  List<Albums> data = [];
  for (var album in jsonDecode(response)) {
    data.add(Albums.fromJson(album));
  }
  return data;
}
