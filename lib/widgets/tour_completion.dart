import 'package:figenie/consts.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CongratulationsModal extends StatefulWidget {
  const CongratulationsModal({super.key});

  @override
  _CongratulationsModalState createState() => _CongratulationsModalState();
}

class _CongratulationsModalState extends State<CongratulationsModal> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Dialog(
            backgroundColor: backgroundColor,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: foregroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/mascot_5.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Congratulations!',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Successfully completed the tour!",
                    style: TextStyle(color: textLightColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _confettiController.stop();
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(secondaryColor),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(backgroundColor),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: FractionalTranslation(
                translation: const Offset(0.0, -0.3),
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.05,
                  numberOfParticles: 20,
                  gravity: 0.9,
                  colors: const [
                    primaryColor,
                    secondaryColor,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
