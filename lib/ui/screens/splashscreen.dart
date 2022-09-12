import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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
      const Duration(seconds: 2),
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
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.pink.withOpacity(0.5),
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "assets/images/bingobg.png",
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ),
            SizedBox(
              width: 500,
              child: Lottie.asset("assets/images/bingo.json",
                  fit: BoxFit.cover, repeat: true, width: 500),
            ),
          ],
        ),
      ),
    );
  }
}
