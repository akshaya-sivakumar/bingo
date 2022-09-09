import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: View(
        numberOfItems: 100,
      ),
    );
  }
}

class Item {
  static final random = Random();
  double? _size;
  Color? _color;

  Alignment? _alignment;

  Item() {
    _color = Color.fromARGB(random.nextInt(255), random.nextInt(255),
        random.nextInt(255), random.nextInt(255));
    _alignment =
        Alignment(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1);
    _size = random.nextDouble() * 40 + 1;
  }
}

class View extends StatefulWidget {
  final int numberOfItems;

  const View({Key? key, required this.numberOfItems}) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> with SingleTickerProviderStateMixin {
  var items = <Item>[];
  var started = false;

  AnimationController? animationController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 500,
          child: Center(
            child: Stack(
              children: <Widget>[
                Scaffold(
                  appBar: AppBar(
                    title: Text("Emoji Example Rain"),
                  ),
                  body: Center(
                    child: RaisedButton(
                      child: Text("Start Dropping"),
                      onPressed: makeItems,
                    ),
                  ),
                ),
                ...buildItems()
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildItems() {
    return items.map((item) {
      var tween = Tween<Offset>(
              begin: Offset(Random().nextDouble() * 0.5, 1),
              end: Offset(0, Random().nextDouble() * -1 - 1))

          //   begin: Offset(0, Random().nextDouble() * -1 - 1),
          // end: Offset(Random().nextDouble() * 0.5, 2))
          .chain(CurveTween(curve: Curves.slowMiddle));
      return SlideTransition(
        position: animationController!.drive(tween),
        child: AnimatedAlign(
          alignment: item._alignment ?? Alignment.center,
          duration: Duration(seconds: 2),
          child: AnimatedContainer(
            duration: Duration(seconds: 2),
            width: item._size,
            height: item._size,
            decoration:
                BoxDecoration(color: item._color, shape: BoxShape.circle),
            child: Image.asset(
              "assets/images/sad.png",
              width: 50,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
  }

  void makeItems() {
    setState(() {
      items.clear();
      for (int i = 0; i < widget.numberOfItems; i++) {
        items.add(Item());
      }
    });
    animationController?.reset();
    animationController?.forward();
  }
}
