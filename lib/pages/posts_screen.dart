import 'dart:convert';
import 'dart:math' as math;

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/models/posts.dart';
import 'comments_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<Post> futurePost;
  late Future<List<Post>> futurePosts;
  @override
  void initState() {
    super.initState();
    futurePost = _fetchPostData();
    futurePosts = _fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Demo'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post> posts = snapshot.data!;
            return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ExpandablePanel(
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                    .toInt())
                                .withOpacity(0.8),
                          ),
                          Text(
                            posts[index].title,
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      collapsed: Column(
                        children: [
                          Text(
                            posts[index].body,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(
                            color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                    .toInt())
                                .withOpacity(0.8),
                          )
                        ],
                      ),
                      expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(posts[index].body, softWrap: true),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        CommentsScreen(posts[index].id))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'comments',
                                    style: TextStyle(
                                        color: Colors.green.shade500,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.comment,
                                    size: 12,
                                    color: Colors.green.shade500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error::${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 35),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Future<Post> _fetchPostData() async {
  //alternative : Uri.parse(//place url here)
  var uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  var response = await http.get(uri);
  return response.statusCode == 200
      ? Post.fromJson(jsonDecode(response.body))
      : throw Exception('failed to fetch data ');
}

Future<List<Post>> _fetchAllPosts() async {
  var uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    List<Post> postList = [];
    for (var data in jsonDecode(response.body)) {
      postList.add(Post.fromJson(data));
    }
    return postList;
  }
  throw Exception('Something went wrong in the fetch block');
}
