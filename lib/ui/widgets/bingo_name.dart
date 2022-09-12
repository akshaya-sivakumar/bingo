import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BingoName extends StatelessWidget {
  final int bingo;
  const BingoName(
    this.bingo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.pink.shade100,
          gradient: LinearGradient(colors: [
            Colors.pink.shade200,
            Colors.white,
            Colors.blue.shade200
          ]),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.pink,
          )),
      width: 280.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < ["B", "I", "N", "G", "O"].length; i++)
            SizedBox(
              width: 45,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    ["B", "I", "N", "G", "O"][i],
                    style: GoogleFonts.chicle(
                        color: Colors.pink,
                        fontWeight: FontWeight.w900,
                        fontSize: 45),
                  ),
                  if (bingo >= i + 1)
                    const Icon(
                      Icons.check,
                      size: 55,
                      color: Colors.black,
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
