import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 4),
      () => navigationPage(),
    );
    super.initState();
  }

  navigationPage() {
    Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      "assets/images/bingobg.png",
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.pinkAccent.withOpacity(0.3),
                        Colors.purpleAccent,
                        Colors.blue.withOpacity(0.3),
                      ],
                    )),
                    child: SizedBox(
                      // width: 400,
                      child: Lottie.asset("assets/images/bingo.json",
                          fit: BoxFit.fill, repeat: true),
                    ),
                  ),
                ],
              ),
            )));
  }
}
