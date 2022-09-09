import 'package:bingo/constants.dart';
import 'package:bingo/ui/widgets/textfield.dart';
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
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/images/bingobg.png",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.pinkAccent.withOpacity(0.3),
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
                          width: 290,
                          child: Text(
                            "Enter your name to begin a game",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.carterOne(
                              color: Colors.tealAccent,
                              fontSize: 24.0,
                            ),
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFieldWidget(
                            color: Colors.white,
                            onChanged: (e) {
                              AppConstants.user = e;
                            },
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
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            gradient: LinearGradient(colors: [
                              Colors.pink[800]!,
                              Colors.red[200]!,
                            ]),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
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
            ),
          ],
        ));
  }
}
