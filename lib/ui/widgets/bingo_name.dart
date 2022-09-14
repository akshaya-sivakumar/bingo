import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      margin: EdgeInsets.symmetric(vertical: 30.h),
      height: 150.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
          color: Colors.pink.shade100,
          gradient: LinearGradient(colors: [
            Colors.pink.shade200,
            Colors.white,
            Colors.blue.shade200
          ]),
          boxShadow: const [
            BoxShadow(color: Colors.red, blurRadius: 10),
          ],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            width: 0.5,
            color: Colors.pink,
          )),
      width: MediaQuery.of(context).size.width * 0.8,
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
                        shadows: [
                          const Shadow(color: Colors.blue, blurRadius: 5)
                        ],
                        fontSize: 90.sp),
                  ),
                  if (bingo >= i + 1)
                    Icon(
                      Icons.check,
                      size: 80.sp,
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
