import 'package:flutter/material.dart';

class BingoBox extends StatelessWidget {
  final String number;
  const BingoBox({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 60,
      width: 60,
      color: ([...Colors.primaries]..shuffle()).first,
      child: Center(
          child: Container(
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(50)),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            number,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      )),
    );
  }
}
