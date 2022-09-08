import 'dart:math' as math;
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bingo/bloc/bingo_game/bingo_game_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BingoGamePage extends StatefulWidget {
  const BingoGamePage({super.key});

  @override
  State<BingoGamePage> createState() => _BingoGamePageState();
}

class _BingoGamePageState extends State<BingoGamePage> {
  int number = 0;
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BingoGameBloc, BingoGameState>(
      builder: (context, state) {
        if (state is BingoProgress) return Container();
        debugPrint(state.selectedList.toString());
        if (state.won) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            hostDialog(context, state.winnerName);
          });
        }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/bingo_name.png"),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(50)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(50)),
                          child: Table(
                            border: TableBorder.all(color: Colors.white),
                            columnWidths: const <int, TableColumnWidth>{
                              0: IntrinsicColumnWidth(),
                              1: IntrinsicColumnWidth(),
                              2: IntrinsicColumnWidth(),
                              3: IntrinsicColumnWidth(),
                              4: IntrinsicColumnWidth(),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              for (int i = 0; i < 5; i++)
                                TableRow(
                                  children: <Widget>[
                                    for (int j = 0; j < 5; j++)
                                      IgnorePointer(
                                        ignoring: state.start == true
                                            ? false
                                            : state.numberList[i][j] != "",
                                        child: InkWell(
                                          onTap: () {
                                            if (state.start == true &&
                                                !state.selectedList.contains(
                                                    state.numberList[i][j])) {
                                              BlocProvider.of<BingoGameBloc>(
                                                      context)
                                                  .add(BingoAddEvent(
                                                      state.numberList[i][j]));
                                            } else if (state.start == false) {
                                              setState(() {
                                                number += 1;
                                                state.numberList[i][j] =
                                                    number.toString();
                                              });
                                            }
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              boxcellWidget(
                                                  state.numberList[i][j]),
                                              if (state.selectedList.contains(
                                                      state.numberList[i][j]) &&
                                                  state.numberList[i][j] != "")
                                                const Icon(
                                                  Icons.close,
                                                  size: 55,
                                                  color: Colors.deepPurple,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        for (var data in state.bingoList) bingoStrike(data),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 250.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0;
                            i < ["B", "I", "N", "G", "O"].length;
                            i++)
                          SizedBox(
                            width: 50,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  ["B", "I", "N", "G", "O"][i],
                                  style: GoogleFonts.alef(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 40),
                                ),
                                if (state.bingoList.length >= i + 1)
                                  const Icon(
                                    Icons.check,
                                    size: 40,
                                    color: Colors.black,
                                  )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!state.numberList
                      .expand((element) => element)
                      .contains(""))
                    InkWell(
                      onTap: () {
                        BlocProvider.of<BingoGameBloc>(context)
                            .add(BingoStartEvent(state.numberList));
                      },
                      child: Image.asset(
                        "assets/images/start.png",
                        width: MediaQuery.of(context).size.width * 0.55,
                      ),
                    ),
                  InkWell(
                    child: Image.asset(
                      "assets/images/quit.png",
                      width: MediaQuery.of(context).size.width * 0.55,
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Positioned bingoStrike(data) {
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

  Container boxcellWidget(String number) {
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

  void hostDialog(BuildContext context, String name) {
    _controllerCenter.play();
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            dialogBackgroundColor: Colors.white,
            context: context,
            // ignore: deprecated_member_use
            animType: AnimType.SCALE,
            customHeader: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.pinkAccent.withOpacity(0.6),
                child: Image.asset("assets/images/bingo_name.png")),
            body: Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "$name wins",
                          style: GoogleFonts.akayaKanadaka(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ConfettiWidget(
                          confettiController: _controllerCenter,
                          blastDirectionality: BlastDirectionality.explosive,
                          blastDirection: pi, // radial value - LEFT
                          particleDrag: 0.05, // apply drag to the confetti
                          emissionFrequency: 0.05, // how often it should emit
                          numberOfParticles: 20, // number of particles to emit
                          gravity: 0.05, // gravity - or fall speed
                          shouldLoop: false,
                          colors: const [
                            Colors.green,
                            Colors.blue,
                            Colors.pink
                          ], // manually specify the colors to be used
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                          createParticlePath: drawStar,
                        ),
                      ),
                    ],
                  )),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            // btnCancelOnPress: () {},
            btnOkOnPress: () {
              Navigator.of(context).pushNamed("/initgame");
            },
            btnOkText: "Close")
        .show();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
