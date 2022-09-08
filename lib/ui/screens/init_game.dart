import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';

class InitGame extends StatefulWidget {
  const InitGame({super.key});

  @override
  State<InitGame> createState() => _InitGameState();
}

class _InitGameState extends State<InitGame> {
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
                Image.asset(
                  "assets/images/bingo_name.png",
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                const SizedBox(
                  height: 20,
                ),
                cardWidget(context, "Join a game", Colors.blueAccent),
                const SizedBox(
                  height: 20,
                ),
                cardWidget(context, "Host a game", Colors.pinkAccent)
              ],
            ),
          ),
        ));
  }

  Widget cardWidget(BuildContext context, String title, Color color) {
    return InkWell(
      onTap: () {
        if (title == "Join a game") {
          Navigator.of(context).pushNamed("/joinGame");
        } else {
          hostDialog(context);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20)),
          height: 100,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Center(
              child: Text(
            title,
            style: GoogleFonts.alegreyaSc(
                fontWeight: FontWeight.w900, fontSize: 25, color: Colors.white),
          )),
        ),
      ),
    );
  }

  void hostDialog(BuildContext context) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            dialogBackgroundColor: const Color.fromRGBO(228, 171, 245, 0.5),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    onMenuStateChange: (isOpen) {},
                    isExpanded: true,
                    hint: Row(
                      children: const [
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Select Max No.of users',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: ["2", "3"]
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.deepPurple,
                                      ),
                                      const Icon(
                                        Icons.person,
                                        color: Colors.deepPurple,
                                      ),
                                      if (item == "3")
                                        const Icon(
                                          Icons.person,
                                          color: Colors.deepPurple,
                                        ),
                                    ],
                                  ),
                                  Text(
                                    item,
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    // value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        // selectedValue = value as String;
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.yellow,
                    iconDisabledColor: Colors.grey,
                    buttonHeight: 50,
                    buttonWidth: 250,
                    buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.pinkAccent.withOpacity(0.6),
                    ),
                    buttonElevation: 2,
                    itemHeight: 40,
                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
                    dropdownMaxHeight: 200,
                    dropdownWidth: 250,
                    dropdownPadding: const EdgeInsets.only(left: 14, right: 14),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.pink.shade100,
                    ),
                    //  dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                    //offset: const Offset(-20, 0),
                  ),
                ),
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              Navigator.of(context).pushNamed("/bingo");
            },
            btnOkText: "Continue")
        .show();
  }
}
