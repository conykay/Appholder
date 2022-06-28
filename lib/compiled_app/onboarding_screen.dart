import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_navigation/compiled_app/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;
  List<Color> colors = [
    Color(0xff8254f7),
    Color(0xfff7dc54),
    Color(0xfff75464),
  ];

  AnimatedContainer _buildDots(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white60,
        borderRadius: BorderRadius.circular(50),
      ),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      curve: Curves.easeIn,
      margin: EdgeInsets.only(left: 5),
    );
  }

  _setFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstTime', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() {
                  _currentPage = value;
                }),
                itemCount: contents.length,
                itemBuilder: (context, index) => Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(50)),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: SvgPicture.asset(
                          contents[index].image,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        contents[index].title,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.white),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        contents[index].desc,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        contents.length, (index) => _buildDots(index)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _currentPage + 1 == contents.length
                          ? ElevatedButton(
                              onPressed: () {
                                _setFirstTime();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => false);
                              },
                              child: Text('Get Started'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black87,
                                onPrimary: Colors.white60,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 50),
                                textStyle:
                                    Theme.of(context).textTheme.headline6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () => _controller.animateToPage(
                                    2,
                                    duration: Duration(milliseconds: 1000),
                                    curve: Curves.easeIn,
                                  ),
                                  child: Text(
                                    'SKIP',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  style: TextButton.styleFrom(
                                      primary: Colors.black87),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                ),
                                ElevatedButton(
                                  onPressed: () => _controller.nextPage(
                                    duration: Duration(milliseconds: 1000),
                                    curve: Curves.easeIn,
                                  ),
                                  child: Text('Next'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black87,
                                    onPrimary: Colors.white60,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    textStyle:
                                        Theme.of(context).textTheme.headline6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
