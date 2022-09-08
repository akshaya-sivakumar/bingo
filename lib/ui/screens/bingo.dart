import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix2d/matrix2d.dart';
import 'package:bingo/model/bingo_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';

import '../../constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> numberList = [];
  List selectedList = [];
  int number = 0;
  bool start = false;
  IOWebSocketChannel? channels;
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    try {
      channels = IOWebSocketChannel.connect(
          Uri.parse('ws://bingo-api-vxbrwrpk5q-el.a.run.app/ws/1'));

      channels?.stream.listen((message) {
        BingoModel bingoDetail = BingoModel.fromJson(json.decode(message));
        if (bingoDetail.value == "winner") {
          channels?.sink.close();
          if (kDebugMode) {
            print(bingoDetail.value);
          }
          hostDialog(context, bingoDetail.name);
        }
        {
          selectedList.add(bingoDetail.value);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });

          checkBingo();
        }

        // channel.sink.close(status.goingAway);
      });
    } catch (e) {
      if (kDebugMode) {
        print("error$e");
      }
    }

    numberList = List.generate(5, (index) => List.generate(5, (i) => ""));
    super.initState();
  }

  List bingoList = [];
  List diaList1 = [];
  List diaList2 = [];
  List horiList = [];

  checkBingo() {
    bingoList = [];

    //-----horizontal and ver list
    for (int i = 0; i < 5; i++) {
      if (Set.of(selectedList).containsAll(numberList[i])) {
        bingoList.add(i);
      }
      if (Set.of(selectedList).containsAll(horiList[i])) {
        bingoList.add(5 + i);
      }
    }

    //-----diagonal

    if (Set.of(selectedList).containsAll(diaList1[0])) {
      bingoList.add(10);
    }
    if (Set.of(selectedList).containsAll(diaList2[0])) {
      bingoList.add(11);
    }
    if (kDebugMode) {
      print("bingolist$bingoList");
    }

    if (bingoList.length >= 5) {
      channels?.sink.add(json
          .encode(
              BingoModel(name: AppConstants.user, value: "winner".toString()))
          .toString());
    }
  }

  void generateList() {
    horiList = List.generate(5, (index) => List.generate(5, (i) => ""));
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        horiList[i][j] = numberList[j][i];
      }
    }
    diaList1 = const Matrix2d().diagonal(numberList);
    diaList2 = const Matrix2d()
        .diagonal(horiList.map((e) => e.reversed.toList()).toList());
  }

  @override
  Widget build(BuildContext context) {
    /* log("selected" + selectedList.toString());
    log("numbers" + numberList.toString()); */
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
                                    ignoring: start == true
                                        ? false
                                        : numberList[i][j] != "",
                                    child: InkWell(
                                      onTap: () {
                                        if (start == true &&
                                            !selectedList
                                                .contains(numberList[i][j])) {
                                          channels?.sink.add(json
                                              .encode(BingoModel(
                                                  name: AppConstants.user,
                                                  value: numberList[i][j]
                                                      .toString()))
                                              .toString());
                                        } else if (start == false) {
                                          setState(() {
                                            number += 1;
                                            numberList[i][j] =
                                                number.toString();
                                          });
                                        }
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          boxcellWidget(numberList[i][j]),
                                          if (selectedList
                                                  .contains(numberList[i][j]) &&
                                              numberList[i][j] != "")
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
                    /* Positioned(
                      right: 120,
                      top: -60,
                      child: Transform.rotate(
                          angle: -math.pi / 1.33,
                          child: Container(
                              alignment: Alignment.topCenter,
                              height: 424,
                              width: 60,
                              child: const VerticalDivider(
                                thickness: 5,
                                color: Colors.black,
                              ))),
                    ), */
                    for (var data in bingoList)
                      Positioned(
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
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 250.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "B",
                          style: GoogleFonts.alef(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 40),
                        ),
                        if (bingoList.isNotEmpty)
                          const Icon(
                            Icons.check,
                            size: 40,
                            color: Colors.deepPurple,
                          )
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "I",
                          style: GoogleFonts.alef(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 40),
                        ),
                        if (bingoList.length >= 2)
                          const Icon(
                            Icons.check,
                            size: 40,
                            color: Colors.deepPurple,
                          )
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "N",
                          style: GoogleFonts.alef(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 40),
                        ),
                        if (bingoList.length >= 3)
                          const Icon(
                            Icons.check,
                            size: 40,
                            color: Colors.deepPurple,
                          )
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "G",
                          style: GoogleFonts.alef(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 40),
                        ),
                        if (bingoList.length >= 4)
                          const Icon(
                            Icons.check,
                            size: 40,
                            color: Colors.deepPurple,
                          )
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "O",
                          style: GoogleFonts.alef(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 40),
                        ),
                        if (bingoList.length >= 5)
                          const Icon(
                            Icons.check,
                            size: 40,
                            color: Colors.deepPurple,
                          )
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                // ignore: iterable_contains_unrelated_type
                onTap: numberList.contains("")
                    ? null
                    : () async {
                        generateList();
                        setState(() {
                          start = true;
                        });
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
            btnOkText: "Continue")
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
