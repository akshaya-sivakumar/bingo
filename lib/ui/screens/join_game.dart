import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class JoinGame extends StatefulWidget {
  static String gamecode = "";
  const JoinGame({super.key});

  @override
  State<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  TextEditingController codecontroller = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple.withOpacity(0.4),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
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
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /* Text(
                                  "JOIN MY ROOM",
                                  style: GoogleFonts.aladin(
                                      fontSize: 30, color: Colors.white),
                                ), */
                                SizedBox(
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
                                          padding: const EdgeInsets.all(30),
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
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "Enter Game code",
                                                style: GoogleFonts.aladin(
                                                    fontSize: 30,
                                                    color: Colors.black),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                child: Form(
                                                  //   key: formKey,
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8,
                                                          horizontal: 5),
                                                      child: PinCodeTextField(
                                                        onTap: () {
                                                          myFocusNode
                                                              .requestFocus();
                                                        },
                                                        appContext: context,
                                                        autoFocus: true,
                                                        //focusNode: myFocusNode,
                                                        pastedTextStyle:
                                                            TextStyle(
                                                          color: Colors
                                                              .green.shade600,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        length: 6,
                                                        obscureText: false,
                                                        obscuringCharacter: '*',
                                                        controller:
                                                            codecontroller,

                                                        blinkWhenObscuring:
                                                            true,
                                                        animationType:
                                                            AnimationType.fade,
                                                        validator: (v) {
                                                          if (v!.length < 3) {
                                                            return null;
                                                            //return "I'm from validator";
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        pinTheme: PinTheme(
                                                          shape:
                                                              PinCodeFieldShape
                                                                  .box,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          fieldHeight: 50,
                                                          inactiveFillColor:
                                                              Colors.white,
                                                          selectedFillColor:
                                                              Colors.white,
                                                          fieldWidth: 40,
                                                          activeColor:
                                                              Colors.white,
                                                          activeFillColor:
                                                              Colors.pink
                                                                  .shade100,
                                                        ),
                                                        cursorColor:
                                                            Colors.black,
                                                        animationDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        enableActiveFill: true,
                                                        // errorAnimationController: errorController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        boxShadows: const [
                                                          BoxShadow(
                                                            offset:
                                                                Offset(0, 1),
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 10,
                                                          )
                                                        ],
                                                        onCompleted: (v) {
                                                          debugPrint(
                                                              "Completed");
                                                        },
                                                        // onTap: () {
                                                        //   print("Pressed");
                                                        // },
                                                        onChanged: (value) {
                                                          debugPrint(value);
                                                          setState(() {
                                                            // currentText = value;
                                                          });
                                                        },
                                                        beforeTextPaste:
                                                            (text) {
                                                          debugPrint(
                                                              "Allowing to paste $text");
                                                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                                          return true;
                                                        },
                                                      )),
                                                ),
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
                                                    onPressed: () {
                                                      JoinGame.gamecode =
                                                          codecontroller.text;
                                                      Navigator.of(context)
                                                          .pushNamed("/bingo");
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Join a game ",
                                                          style: GoogleFonts
                                                              .akayaKanadaka(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 22),
                                                        ),
                                                      ],
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 25,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.deepPurple.shade400,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 15),
                                            child: Text(
                                              "Join a game",
                                              style:
                                                  GoogleFonts.akayaTelivigala(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
