import 'package:figenie/consts.dart';
import 'package:flutter/widgets.dart';

class Placeholder extends StatelessWidget {
  const Placeholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: foregroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/mascot_2.png", width: 196, height: 196),
            const Text(
              "Nothing here yet...",
              style: TextStyle(
                  color: textLighterColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
