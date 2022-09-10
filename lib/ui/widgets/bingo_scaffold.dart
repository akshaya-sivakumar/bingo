import 'package:flutter/material.dart';

class Bingoscaffold extends StatelessWidget {
  final Widget child;
  final Widget? floatingButton;
  const Bingoscaffold({Key? key, required this.child, this.floatingButton})
      : super(key: key);

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
          child: Center(child: child)),
      floatingActionButton: floatingButton,
    );
  }
}
