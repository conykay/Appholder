import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:new_navigation/pages/users_screen.dart';
import 'package:provider/provider.dart';

import '/models/change_notifiers/todos_notifier.dart';
import 'albums_screen.dart';
import 'posts_screen.dart';
import 'todos_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int currentIndex = 0;
  late AnimationController _hide;
  @override
  void initState() {
    super.initState();
    _hide = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _hide.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (notification.direction) {
          case ScrollDirection.forward:
            _hide.forward();
            break;
          case ScrollDirection.reverse:
            _hide.reverse();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        body: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case '/':
                builder = (context) => PostsScreen();
                break;
              case '/users':
                builder = (context) => UsersScreen();
                break;
              case '/albums':
                builder = (context) => AlbumsScreen();
                break;
              case '/todos':
                builder = (context) => ChangeNotifierProvider(
                      create: (context) => TodosList(),
                      child: const TodosScreen(),
                    );
                break;
              default:
                throw Exception('Invalid route ${settings.name}');
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
        bottomNavigationBar: SizeTransition(
          sizeFactor: _hide,
          axisAlignment: -1.0,
          child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (int index) => {
                    setState(() {
                      currentIndex = index;
                      if (currentIndex == 0) {
                        _navigatorKey.currentState?.pushNamed('/');
                      } else if (currentIndex == 1) {
                        _navigatorKey.currentState?.pushNamed('/users');
                      } else if (currentIndex == 2) {
                        _navigatorKey.currentState?.pushNamed('/albums');
                      } else {
                        _navigatorKey.currentState?.pushNamed('/todos');
                      }
                    })
                  },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: 'Users',
                    backgroundColor: Colors.red),
                BottomNavigationBarItem(
                    icon: Icon(Icons.album),
                    label: 'Albums',
                    backgroundColor: Colors.purple),
                BottomNavigationBarItem(
                    icon: Icon(Icons.task),
                    label: 'Tasks',
                    backgroundColor: Colors.green),
              ]),
        ),
      ),
    );
  }
}
// {
// '/': (context) => HomeScreen(),
// '/posts': (context) => PostsScreen(),
// '/albums': (context) => AlbumsScreen(),
// '/users': (context) => UsersScreen(),
// '/todos':
// // '/comments': (context) => CommentsScreen(),
// }
/* todo: implement navigation bar :
* practice controllers and animations.
* understand global keys.
* index stack as a navigation option
* understand Navigation principles.
*  */
