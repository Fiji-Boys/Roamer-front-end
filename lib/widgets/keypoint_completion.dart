import 'package:figenie/consts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CompletedKeypointModal extends StatefulWidget {
  final VoidCallback onAnimationCompleted;

  const CompletedKeypointModal({super.key, required this.onAnimationCompleted});

  @override
  State<CompletedKeypointModal> createState() => _CompletedKeypointModalState();
}

class _CompletedKeypointModalState extends State<CompletedKeypointModal> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(milliseconds: 1800), widget.onAnimationCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Keypoint Completed",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor),
            ),
            const SizedBox(height: 16.0),
            Lottie.asset(
              'assets/checkmark.json',
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
