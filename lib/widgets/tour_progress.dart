import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Current Key Point',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tour.keyPoints[0].name,
                    style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 32.0,
              backgroundColor: secondaryColor,
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(tour.keyPoints[0].images[0]),
                backgroundColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
