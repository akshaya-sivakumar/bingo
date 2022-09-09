import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodePage extends StatefulWidget {
  const CodePage({super.key});

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  TextEditingController codecontroller = TextEditingController();
  String? code;

  @override
  void initState() {
    code = getRandomString(6);
    super.initState();
  }

  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple.withOpacity(0.4),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.pinkAccent.withOpacity(0.5),
              Colors.purpleAccent,
              Colors.blueAccent.withOpacity(0.5),
            ],
          )),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "JOIN MY ROOM",
                        style: GoogleFonts.aladin(fontSize: 30),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 50,
                            color: Colors.orange,
                            child: Text("share and invite"),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              padding: EdgeInsets.all(30),
                              height: 400,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Game Code : $code",
                                        style: GoogleFonts.akayaKanadaka(
                                            fontSize: 30)),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "Share this game code with your friends to invite them to this game",
                                      style: GoogleFonts.abel(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.pink),
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Share ",
                                                style:
                                                    GoogleFonts.akayaKanadaka(
                                                        color: Colors.white,
                                                        fontSize: 22),
                                              ),
                                              Icon(
                                                Icons.share,
                                                color: Colors.white,
                                              )
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            child: Container(
                              height: 50,
                              color: Colors.orange,
                              child: Text("share and invite"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
