import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BingoScaffold extends StatelessWidget {
  final Widget child;
  const BingoScaffold({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.pinkAccent.withOpacity(0.2),
                Colors.purpleAccent,
                Colors.blue.withOpacity(0.3),
              ],
            )),
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child:child)));
  }
}