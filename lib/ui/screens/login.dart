import 'dart:convert';
import 'dart:developer';

import 'dart:math' as math;
import 'package:bingo/ui/widgets/textfield.dart';
import 'package:matrix2d/matrix2d.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bingo/model/bingo_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<List<String>> numberList = [];
  List selectedList = [];
  int number = 0;
  bool start = false;
  IOWebSocketChannel? channels;
  TextEditingController namecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
              Colors.pinkAccent.withOpacity(0.2),
              Colors.purpleAccent,
              Colors.blue.withOpacity(0.3),
            ],
          )),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.2),
                    child: Image.asset(
                      "assets/images/bingo.png",
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  SizedBox(
                      width: 190,
                      child: Text(
                        "Enter your name to begin a game",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.carterOne(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFieldWidget(
                        color: Colors.white,
                        controller: namecontroller,
                        title: "Enter your name"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/initgame");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        gradient: LinearGradient(colors: [
                          Colors.red[800]!,
                          Colors.red[200]!,
                        ]),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Play BINGO",
                        style: GoogleFonts.alfaSlabOne(
                            color: Colors.white,
                            //  fontWeight: FontWeight.w900,
                            fontSize: 17),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
