import 'package:figenie/consts.dart';
import 'package:flutter/widgets.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: foregroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/mascot_0.png",
              width: 196,
              height: 196,
            ),
            const Text(
              "Loading...",
              style: TextStyle(
                  color: textLighterColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
