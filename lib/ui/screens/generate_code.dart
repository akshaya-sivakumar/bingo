import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

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
          child: Stack(
            children: [
              Image.asset(
                "assets/images/bingobg.png",
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
              ),
              Container(
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
                              style: GoogleFonts.aladin(
                                  fontSize: 30, color: Colors.white),
                            ),
                            Container(
                              height: 500,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Container(
                                      padding: EdgeInsets.all(30),
                                      height: 400,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Colors.blue.shade200,
                                              Colors.white,
                                              Colors.pink.shade200,
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              child: Lottie.asset(
                                                "assets/images/bingogame.json",
                                                fit: BoxFit.fill,
                                                repeat: true,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("Game Code : $code",
                                                style:
                                                    GoogleFonts.akayaKanadaka(
                                                        fontSize: 30)),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "Share this game code with your friends to invite them to this game",
                                              style: GoogleFonts.abel(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.pink),
                                                  onPressed: () {},
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Share ",
                                                        style: GoogleFonts
                                                            .akayaKanadaka(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 22),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _onShareWithResult(
                                                              context);
                                                        },
                                                        child: Icon(
                                                          Icons.share,
                                                          color: Colors.white,
                                                        ),
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
                                    top: 25,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 15),
                                        child: Text(
                                          "share and invite",
                                          style: GoogleFonts.akayaTelivigala(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _onShareWithResult(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    ShareResult result;

    if (code != "") {
      result = await Share.shareWithResult(
        code ?? "ak",
        subject: "BINGO - Game Code",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Share result: ${result.status}"),
      ));
    }
  }
}
