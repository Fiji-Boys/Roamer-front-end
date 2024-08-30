import 'package:figenie/consts.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: foregroundColor,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   "assets/mascot_0.png",
            //   width: 196,
            //   height: 196,
            // ),
            SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              ),
            ),
            // const Text(
            //   "Loading...",
            //   style: TextStyle(
            //       color: textLighterColor, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
