import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';

class DialogWidget {
  static void hostDialog(BuildContext context, String name) {
    AwesomeDialog(
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      dialogBackgroundColor: Colors.pink.shade100,
      context: context, bodyHeaderDistance: 0,
      dialogBorderRadius: BorderRadius.circular(50),
      isDense: false,

      // closeIcon: Icon(Icons.close),
      // showCloseIcon: true,
      // ignore: deprecated_member_use
      animType: AnimType.bottomSlide,
      borderSide: const BorderSide(color: Colors.pink, width: 2),
      barrierColor: Colors.orangeAccent.withOpacity(0.5),
      padding: EdgeInsets.zero,
      customHeader: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white.withOpacity(0.5),
        child: Lottie.asset(
          AppConstants.user == name
              ? "assets/images/winners.json"
              : "assets/images/loser.json",
          fit: BoxFit.fill,
          repeat: true,
        ),
      ),
      body: StatefulBuilder(builder: (context, setstate) {
        return Center(
          child: Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                // color: Colors.pinkAccent.withOpacity(0.4),
                image: const DecorationImage(
                  image: AssetImage(
                    "assets/images/popupbg.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.3,
              // padding: const EdgeInsets.only(top: 20),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // if (name == AppConstants.user)
                  Positioned(
                      top: 0,
                      child: Image.asset(
                        name == AppConstants.user
                            ? "assets/images/congrats.png"
                            : "assets/images/oops.png",
                        width: 300,
                        height: 200,
                        fit: BoxFit.fill,
                      )),
                  Positioned(
                    top: name == AppConstants.user ? 150 : 160,
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        name == AppConstants.user ? "You wins !" : "You lose !",
                        style: GoogleFonts.adamina(
                            color: name == AppConstants.user
                                ? Colors.white
                                : Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 25),
                      ),
                    ),
                  ),
                  if (name == AppConstants.user)
                    const Align(
                      alignment: Alignment.center,
                      child: Blast(),
                    ),
                ],
              )),
        );
      }),
      title: 'This is Ignored',
      desc: 'This is also Ignored',
      // btnCancelOnPress: () {},
      btnOkOnPress: () {},
      btnOk: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/initgame", (r) => false);
        },
        child: Image.asset(
          "assets/images/replay.png",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.4,
        ),
      ),
      btnCancel: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/initgame", (r) => false);
        },
        child: Image.asset(
          "assets/images/quit.png",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.4,
        ),
      ),
    ).show();
  }
}

class Blast extends StatefulWidget {
  const Blast({Key? key}) : super(key: key);

  @override
  State<Blast> createState() => _BlastState();
}

class _BlastState extends State<Blast> {
  late ConfettiController _controllerCenter;
  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 2));
    _controllerCenter.play();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
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
        Colors.pink,
        Colors.red,
        Colors.yellow
      ], // manually specify the colors to be used
      strokeWidth: 1,
      strokeColor: Colors.white,
      // createParticlePath: drawStar,
    );
  }

  /* static Path drawStar(Size size) {
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
  } */
}
