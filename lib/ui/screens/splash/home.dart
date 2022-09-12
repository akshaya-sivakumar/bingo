import 'package:bingo/ui/screens/splash/animation.dart';
import 'package:bingo/ui/screens/splashscreen.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(children: <Widget>[
      const Splash(),
      IgnorePointer(
          child: AnimationScreen(
        color: Colors.purpleAccent,
      ))
    ]));
  }
}
