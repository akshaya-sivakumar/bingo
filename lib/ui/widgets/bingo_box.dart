import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BingoBox extends StatelessWidget {
  final String number;
  const BingoBox({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(MediaQuery.of(context).size.height * 0.09);
      print(MediaQuery.of(context).size.width * 0.15279);
    }
    return Container(
      padding: EdgeInsets.zero,
      height: 98.h,
      width: 98.h,
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
