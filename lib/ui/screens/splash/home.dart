import 'package:bingo/ui/screens/splash/animation.dart';
import 'package:bingo/ui/screens/splashscreen.dart';


import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(children: const <Widget>[
      Splash(),
      IgnorePointer(
          child: AnimationScreen(
        color: Colors.purpleAccent,
      ))
    ]));
  }
}
