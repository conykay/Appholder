import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/users.dart';
import 'user_info_location.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<User>> fetchUsers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers = _fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.red.shade500,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              UserLocationScreen(user: users[index]))),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _identifierRow(users, index),
                          const Divider(),
                          _emailWebInfo(users, index),
                          _contactRow(users, index)
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Opps! we did it again.',
                style: TextStyle(color: Colors.red, fontSize: 20),
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

  Padding _contactRow(List<User> users, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Icon(
            Icons.phone,
            color: Colors.green,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            users[index].phone,
            style: TextStyle(fontSize: 15, color: Colors.black54),
          )
        ],
      ),
    );
  }

  Padding _emailWebInfo(List<User> users, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email',
                style: TextStyle(fontSize: 12, color: Colors.green),
              ),
              Text(users[index].email,
                  style: TextStyle(fontSize: 15, color: Colors.black54)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Website',
                  style: TextStyle(fontSize: 12, color: Colors.green)),
              Text(users[index].website,
                  style: TextStyle(fontSize: 15, color: Colors.black54)),
            ],
          )
        ],
      ),
    );
  }

  Row _identifierRow(List<User> users, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor:
              Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                users[index].name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
              Text(
                '@${users[index].name}',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ],
          ),
        )
      ],
    );
  }
}

Future<List<User>> _fetchAllUsers() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/users');
  List<User> users = [];
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    var parsed = jsonDecode(response.body);
    for (var user in parsed) {
      users.add(User.fromJson(user));
    }
    return users;
  }
  throw Exception('Something went wrong!');
}
