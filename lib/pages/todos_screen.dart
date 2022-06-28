import 'package:flutter/material.dart';
import 'package:new_navigation/compiled_app/models/change_notifiers/todos_notifier.dart';
import 'package:new_navigation/compiled_app/models/todos.dart';
import 'package:provider/provider.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  var provided =
      (BuildContext context) => Provider.of<TodosList>(context, listen: false);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provided(context).fetchAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        backgroundColor: Colors.green.shade500,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<TodosList>(
        builder: (context, todos, child) {
          if (todos.length > 0 && todos.current == DataState.complete) {
            return _buildListView(todos);
          } else if (todos.current == DataState.error) {
            return _errorScreen();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Center _errorScreen() {
    return Center(
        child: Text(
      'Sorry! we are working to fix it ;)',
      style: TextStyle(fontSize: 20, color: Colors.red),
    ));
  }

  ListView _buildListView(TodosList todos) {
    return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          Todos todo = todos.todos[index];
          return ListTile(
            leading: Checkbox(
              value: todo.completed,
              onChanged: (v) => !todo.completed,
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: todo.completed ? Colors.grey : Colors.black87,
                  decoration:
                      todo.completed ? TextDecoration.lineThrough : null),
            ),
          );
        });
  }
}
