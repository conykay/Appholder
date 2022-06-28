import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home_page.dart';
import 'pages/onboarding_screen.dart';

void main() {
  runApp(App());
}

//todo: Implement firebase authentication.

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var _firstTime;

  _firstTimeChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bool isFirst = ((prefs.getBool('firstTime') ?? true));
      print(isFirst);
      _firstTime = isFirst;
    });
  }

  @override
  void initState() {
    super.initState();
    _firstTimeChecker();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Nunito'),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: _firstTime == null
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : (_firstTime ? OnboardingScreen() : HomePage()),
    );
  }
}
