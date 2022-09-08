import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bingo/ui/widgets/starwidget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WinnerDialog {
  static void hostDialog(BuildContext context, String name) {
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
                      const WinnerWidget()
                    ],
                  )),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/initgame", (e) => false);
            },
            btnOkText: "Close")
        .show();
  }
}

class WinnerWidget extends StatefulWidget {
  const WinnerWidget({Key? key}) : super(key: key);

  @override
  State<WinnerWidget> createState() => _WinnerWidgetState();
}

class _WinnerWidgetState extends State<WinnerWidget> {
  late ConfettiController _controllerCenter;
  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: _controllerCenter,
        blastDirectionality: BlastDirectionality.explosive,
        blastDirection: pi,
        particleDrag: 0.05,
        emissionFrequency: 0.05,
        numberOfParticles: 20,
        gravity: 0.05,
        shouldLoop: false,
        colors: const [Colors.green, Colors.blue, Colors.pink],
        strokeWidth: 1,
        strokeColor: Colors.white,
        createParticlePath: drawStar,
      ),
    );
  }
}
