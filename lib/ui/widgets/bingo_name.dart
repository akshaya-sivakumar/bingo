
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
    return SizedBox(
      width: 250.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < ["B", "I", "N", "G", "O"].length; i++)
            SizedBox(
              width: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    ["B", "I", "N", "G", "O"][i],
                    style: GoogleFonts.alef(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 40),
                  ),
                  if (bingo >= i + 1)
                    const Icon(
                      Icons.check,
                      size: 40,
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
