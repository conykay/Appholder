import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../todos.dart';

enum DataState { loading, complete, error }

class TodosList extends ChangeNotifier {
  List<Todos> _todos = [];

  DataState current = DataState.loading;

  UnmodifiableListView get todos => UnmodifiableListView(_todos);

  int get length => _todos.length;

  void fetchAllTodos() async {
    if (todos.isEmpty) {
      _todos = await _getTodos();
      current = DataState.complete;
      notifyListeners();
    }
  }

  //Network calls.
  Future<List<Todos>> _getTodos() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return await compute(parseTodos, response.body);
    }
    current = DataState.error;
    notifyListeners();
    throw Exception('There was a problem with the response');
  }
}

//lesson:should be a top level function otherwise compute() wont work.
List<Todos> parseTodos(String response) {
  var data = jsonDecode(response);
  List<Todos> finalList = [];
  for (var todo in data) {
    finalList.add(Todos.fromJson(todo));
  }
  return finalList;
}
