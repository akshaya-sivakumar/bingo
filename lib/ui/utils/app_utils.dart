import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bingo_game/bingo_game_bloc.dart';

class AppUtils {
  static Positioned bingoStrike(data) {
    return Positioned(
      left: data > 9
          ? 120
          : (data > 5 && data < 10)
              ? ((data - 5) * 60).toDouble()
              : 0,
      top: data > 9
          ? -60
          : (data < 5 && data < 10)
              ? (data * 60) + 25.toDouble()
              : 0,
      child: Transform.rotate(
          angle: data == 10
              ? math.pi / 1.33
              : data == 11
                  ? -math.pi / 1.33
                  : -math.pi / 1,
          child: Container(
            height: data > 9
                ? 424
                : (data < 5)
                    ? 0
                    : 300,
            alignment: Alignment.topCenter,
            width: data > 9
                ? 60
                : (data < 5 && data < 10)
                    ? 300
                    : 60,
            child: (data < 5)
                ? const Divider(
                    thickness: 5,
                    color: Colors.black,
                  )
                : const VerticalDivider(
                    thickness: 5,
                    color: Colors.black,
                  ),
          )),
    );
  }

  static Widget start(BuildContext context, List<List<String>> numberList) {
    return InkWell(
      onTap: () {
        BlocProvider.of<BingoGameBloc>(context)
            .add(BingoStartEvent(numberList));
      },
      child: Image.asset(
        "assets/images/start.png",
        width: MediaQuery.of(context).size.width * 0.55,
      ),
    );
  }

  static Widget quit(BuildContext context) {
    return InkWell(
      child: Image.asset(
        "assets/images/quit.png",
        width: MediaQuery.of(context).size.width * 0.55,
      ),
      onTap: () async {
        Navigator.pop(context);
      },
    );
  }
}
