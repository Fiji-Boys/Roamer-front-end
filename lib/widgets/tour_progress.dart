import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:flutter/material.dart';
import 'package:figenie/model/tour.dart'; // Import your Tour and KeyPoint models

class TourProgressWidget extends StatelessWidget {
  final Tour tour;
  const TourProgressWidget({
    super.key,
    required this.tour,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 380,
        height: 100,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: foregroundColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5,
              spreadRadius: 0.1,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tour Progress',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Current Key Point:',
                  style: TextStyle(
                    color: textLighterColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  tour.keyPoints[0].name,
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
