import 'dart:math';

import 'package:bingo/bloc/bingo/bingo_bloc_bloc.dart';
import 'package:bingo/ui/screens/join_game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class CodePage extends StatefulWidget {
  static String? type;
  const CodePage({super.key});

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  TextEditingController codecontroller = TextEditingController();
  String? code;
  late BingoBlocBloc bingobloc;
  bool waiting = true;
  @override
  void initState() {
    CodePage.type = "host";
    bingobloc = BlocProvider.of<BingoBlocBloc>(context);
    code = getRandomString(6);
    JoinGame.gamecode = code ?? "";

    bingobloc.add(BingohostEvent(code ?? ""));
    bingobloc.stream.listen((event) {
      if (event.userJoined) {
        if (kDebugMode) {
          print("userJoined- ${event.userJoined}");
        }
        waiting = false;
        bingobloc.close();
        Navigator.of(context).pushReplacementNamed("/bingo");
      }
    });
    super.initState();
  }

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple.withOpacity(0.4),
        body: SizedBox(
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
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "JOIN MY ROOM",
                        style: GoogleFonts.aladin(
                            fontSize: 40.sp, color: Colors.white),
                      ),
                      SizedBox(
                        height: 870.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Container(
                                padding: EdgeInsets.all(30.h),
                                height: 800.h,
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
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 280.h,
                                        height: 280.h,
                                        child: Lottie.asset(
                                          "assets/images/bingogame.json",
                                          fit: BoxFit.fill,
                                          repeat: true,
                                        ),
                                      ),
                                      Text("Game Code : $code",
                                          style: GoogleFonts.akayaKanadaka(
                                              fontSize: 50.sp)),
                                      Text(
                                        "Share this game code with your friends to invite them to this game",
                                        style: GoogleFonts.abel(
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      shareButton(context),
                                      enterroomButton(context)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              child: Container(
                                height: 70.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 20.h),
                                  child: Text(
                                    "share and invite",
                                    style: GoogleFonts.akayaTelivigala(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 35.sp),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (waiting) turnCheck(context)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget shareButton(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(top: 10.h),
      height: 80.h,
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.pink),
          onPressed: () {
            _onShareWithResult(context);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Share ",
                style: GoogleFonts.akayaKanadaka(
                    color: Colors.white, fontSize: 35.sp),
              ),
              Icon(
                Icons.share,
                color: Colors.white,
                size: 35.sp,
              )
            ],
          )),
    );
  }

  SizedBox enterroomButton(BuildContext context) {
    return SizedBox(
      height: 80.h,
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            JoinGame.gamecode = code ?? "";

            Navigator.of(context).pushNamed("/bingo");
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter into the room ",
                style: GoogleFonts.akayaKanadaka(
                    color: Colors.white, fontSize: 35.sp),
              ),
              Icon(
                Icons.login,
                color: Colors.white,
                size: 35.sp,
              )
            ],
          )),
    );
  }

  void _onShareWithResult(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    // ignore: unused_local_variable
    ShareResult result;

    if (code != "") {
      result = await Share.shareWithResult(
        code ?? "ak",
        subject: "BINGO - Game Code",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );

      // ignore: use_build_context_synchronously
      /*   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Share result: ${result.status}"),
      )); */
    }
  }

  Container turnCheck(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitWave(
            color: Colors.white,
            size: 25,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Wait Until other user to join",
            style: GoogleFonts.chicle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
