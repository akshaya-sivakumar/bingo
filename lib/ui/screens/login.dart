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
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.pinkAccent.withOpacity(0.5),
                  Colors.purpleAccent,
                  Colors.blue.withOpacity(0.5),
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
                      Container(
                        height: 250, width: 450,
                        //  width: MediaQuery.of(context).size.width * 0.8,
                        /* decoration: BoxDecoration(
                            border: Border.all(color: Colors.pink),
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.purple.shade200), */
                        padding: const EdgeInsets.all(5),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: 0.7,
                              child: Container(
                                height: 250,
                                width: 450,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            "assets/images/initgame.png"))),
                                child: Image.asset(
                                  "assets/images/initgame.png",
                                  fit: BoxFit.fill,
                                  height: 250,
                                  width: 450,
                                  color: Colors.deepPurple.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 200,
                              width: 450,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 250,
                                      child: Text(
                                        "Enter your name to begin a game",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.alegreyaSansSc(
                                            color: Colors.black,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(3.0, 3.0),
                                                blurRadius: 3.0,
                                                color: Colors.pink,
                                              ),
                                              Shadow(
                                                offset: Offset(3.0, 3.0),
                                                blurRadius: 8.0,
                                                color: Colors.pink,
                                              ),
                                            ],
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w900),
                                      )),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextFieldWidget(
                                        color: Colors.white,
                                        onChanged: (e) {
                                          AppConstants.user = e;
                                        },
                                        controller: namecontroller,
                                        title: "Type here..."),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/initgame");
                        },
                        child: Image.asset(
                          "assets/images/playbtn.png",
                          width: MediaQuery.of(context).size.width * 0.5,
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
