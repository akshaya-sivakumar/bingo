import 'package:bingo/ui/screens/bingo.dart';
import 'package:bingo/ui/screens/join_game.dart';
import 'package:bingo/ui/screens/init_game.dart';
import 'package:bingo/ui/screens/login.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name == "/") {
    return MaterialPageRoute(
      builder: (_) => const Login(),
    );
  } else if (settings.name == "/initgame") {
    return MaterialPageRoute(
      builder: (_) => const InitGame(),
    );
  } else if (settings.name == "/joinGame") {
    return MaterialPageRoute(
      builder: (_) => const JoinGame(),
    );
  } else if (settings.name == "/bingo") {
    return MaterialPageRoute(
      builder: (_) => const MyHomePage(),
    );
  } else {
    return _errorRoute();
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error PAge"),
      ),
      body: const Center(
        child: Text('Page Not Found'),
      ),
    );
  });
}
