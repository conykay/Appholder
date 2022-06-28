import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/comments.dart';

List<Comments> comments = [];

class CommentsScreen extends StatefulWidget {
  const CommentsScreen(this.postId);
  final int postId;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late Future<List<Comments>> fetchComments;

  @override
  void initState() {
    super.initState();
    fetchComments = _fetchPostComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post ${widget.postId} comments.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Comments>>(
        future: fetchComments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Comments> comments = snapshot.data!;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comments[index].email,
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            comments[index].name,
                            style: TextStyle(
                                fontSize: 15, color: Colors.lightBlueAccent),
                          ),
                        ],
                      ),
                      subtitle: Text(comments[index].body),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "${snapshot.error}",
                style: TextStyle(color: Colors.red, fontSize: 35),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

Future<List<Comments>> _fetchPostComments(int postId) async {
  if (comments.isEmpty) {
    var uri = Uri.parse('https://jsonplaceholder.typicode.com/comments');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var comment in data) {
        comments.add(Comments.fromJson(comment));
      }
    }
    throw Exception('something fd up');
  }
  List<Comments> sorted =
      comments.where((element) => element.postId == postId).toList();

  return sorted;
}
