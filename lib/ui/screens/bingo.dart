import 'dart:math' as math;

import 'package:bingo/bloc/bingo/bingo_bloc_bloc.dart';
import 'package:bingo/ui/screens/generate_code.dart';
import 'package:bingo/ui/screens/join_game.dart';

import 'package:bingo/ui/widgets/bingo_box.dart';
import 'package:bingo/ui/widgets/bingo_name.dart';
import 'package:bingo/ui/widgets/bingo_scaffold.dart';
import 'package:bingo/ui/widgets/dialog_widget.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bingo/model/bingo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class MyHomePage extends StatefulWidget {
  static bool musicPlay = true;
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  bool autoFill = false;
  int number = 0;
  @override
  void initState() {
    BlocProvider.of<BingoBlocBloc>(context)
        .add(BingohostEvent(JoinGame.gamecode));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Bingoscaffold(
        floatingButton: BlocBuilder<BingoBlocBloc, BingoBlocState>(
      builder: (context, state) {
        if (state is BingoProgressstate) {
          return Container();
        }
        return floatingButton(state, context);
      },
    ), child: BlocBuilder<BingoBlocBloc, BingoBlocState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          DialogWidget.hostDialog(context, state.winnerName.toString());
        });
        if (state is BingoClosestate) {
          if (state.opponentLeft) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${state.username} left"),
                duration: const Duration(seconds: 10),
              ));
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/initgame", (route) => false);
            });
          }
        } else if (state.won) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            DialogWidget.hostDialog(context, state.winnerName.toString());
          });
        } else if (state is BingoProgressstate) {
          return Container();
        }
        /* if (state is BingoBlocState && !state.won && state.start) {
            AudioPlayer().play(
              AssetSource('audio/tone.mp3'),
            );
          } */

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/images/bingo_name.png",
              width: MediaQuery.of(context).size.width * 0.65,
            ),
            bingoTable(state, context),
            if (state.start) BingoName(state.bingoList.length),
            if (state.opponentMove) turnCheck(context, state),
            if (!state.numberList.expand((element) => element).contains("") &&
                !state.start)
              startButton(context, state),
            /*   if (state.start == true)
              const SizedBox(
                height: 30,
              ), */
            //exitButton(context, state)
          ],
        );
      },
    ));
  }

  FabCircularMenu floatingButton(BingoBlocState state, BuildContext context) {
    return FabCircularMenu(
        key: fabKey,
        animationDuration: const Duration(milliseconds: 100),
        fabMargin: const EdgeInsets.all(0),
        fabSize: 60,
        fabElevation: 10,
        ringDiameter: 310,
        fabCloseColor: Colors.pink.shade300,
        fabOpenColor: Colors.pink.shade300,
        fabCloseIcon: Image.asset("assets/images/cross.png"),
        ringColor: Colors.pink.withOpacity(0.5),
        fabOpenIcon: Image.asset(
          "assets/images/setting.png",
          fit: BoxFit.cover,
        ),
        children: <Widget>[
          InkWell(
              child: Image.asset(
                MyHomePage.musicPlay
                    ? "assets/images/music.png"
                    : "assets/images/musicoff.png",
                width: 53,
              ),
              onTap: () {
                fabKey.currentState?.close();
                setState(() {
                  MyHomePage.musicPlay = !MyHomePage.musicPlay;
                });
              }),
          if (!state.start)
            InkWell(
                child: Image.asset(
                  autoFill
                      ? "assets/images/retry.png"
                      : "assets/images/autofill.png",
                  width: 55,
                ),
                onTap: () {
                  fabKey.currentState?.close();
                  autoFill = !autoFill;
                  BlocProvider.of<BingoBlocBloc>(context)
                      .add(BingoAutofillEvent(autoFill));
                }),
          InkWell(
              child: Image.asset(
                "assets/images/exit.png",
                width: 55,
              ),
              onTap: () {
                if (state.start == false) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/initgame", (route) => false);
                } else {
                  BlocProvider.of<BingoBlocBloc>(context).add(BingoAddEvent(
                      BingoModel(name: AppConstants.user, value: "Exit")));
                }
              }),
        ]);
  }

  Container turnCheck(BuildContext context, BingoBlocState state) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(top: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 11.sp),
      width: MediaQuery.of(context).size.width * 0.45,
      height: 61.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitWave(
            color: Colors.white,
            size: 35.sp,
          ),
          SizedBox(
            width: 7,
          ),
          Text(
            "Opponent's turn...",
            style: GoogleFonts.adventPro(color: Colors.white),
          )
        ],
      ),
    );
  }

  InkWell exitButton(BuildContext context, BingoBlocState state) {
    return InkWell(
      child: Image.asset(
        "assets/images/quit.png",
        width: MediaQuery.of(context).size.width * 0.4,
      ),
      onTap: () async {},
    );
  }

  InkWell startButton(BuildContext context, BingoBlocState state) {
    return InkWell(
      // ignore: iterable_contains_unrelated_type
      onTap: () {
        BlocProvider.of<BingoBlocBloc>(context)
            .add(BingoStartEvent(state.numberList));
      },
      child: Image.asset(
        "assets/images/start.png",
        width: MediaQuery.of(context).size.width * 0.5,
      ),
    );
  }

  Widget bingoTable(BingoBlocState state, BuildContext context) {
    return IgnorePointer(
      ignoring: state.opponentMove,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
            color: Colors.pink, borderRadius: BorderRadius.circular(50)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(50)),
              child: Table(
                border: TableBorder.all(color: Colors.white),
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: IntrinsicColumnWidth(),
                  2: IntrinsicColumnWidth(),
                  3: IntrinsicColumnWidth(),
                  4: IntrinsicColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  for (int i = 0; i < 5; i++)
                    TableRow(
                      children: <Widget>[
                        for (int j = 0; j < 5; j++)
                          numberBox(state, i, j, context),
                      ],
                    ),
                ],
              ),
            ),
            for (var datas in state.bingoList) bingoLinelogic(datas),
          ],
        ),
      ),
    );
  }

  IgnorePointer numberBox(
      BingoBlocState state, int i, int j, BuildContext context) {
    return IgnorePointer(
      ignoring: state.start == true
          ? false
          : state.opponentMove || state.numberList[i][j] != "",
      child: InkWell(
        onTap: () {
          if (state.start == true &&
              !state.selectedList.contains(state.numberList[i][j])) {
            BlocProvider.of<BingoBlocBloc>(context).add(BingoAddEvent(
                BingoModel(
                    name: AppConstants.user,
                    value: state.numberList[i][j].toString())));
          } else if (state.start == false) {
            setState(() {
              number += 1;
              state.numberList[i][j] = number.toString();
            });
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            BingoBox(number: state.numberList[i][j]),
            if (state.selectedList.contains(state.numberList[i][j]) &&
                state.numberList[i][j] != "")
              Image.asset(
                "assets/images/cross.png",
                width: MediaQuery.of(context).size.width * 0.125,
              ),
          ],
        ),
      ),
    );
  }

  Positioned bingoLinelogic(data) {
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
}
