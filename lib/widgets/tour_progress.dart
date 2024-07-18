import 'package:figenie/model/key_point.dart';
import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';

class TourProgressWidget extends StatelessWidget {
  final Tour tour;
  final int nextKeyPointIndex;

  const TourProgressWidget({
    super.key,
    required this.tour,
    required this.nextKeyPointIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (nextKeyPointIndex < 0 || nextKeyPointIndex >= tour.keyPoints.length) {
      return Container();
    }

    KeyPoint nextKeyPoint = tour.keyPoints[nextKeyPointIndex];

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
                    'Next Key Point',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      nextKeyPoint.name,
                      style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2, // Adjust max lines as needed
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 32.0, // Adjust the size of the outer CircleAvatar
              backgroundColor: secondaryColor,
              child: CircleAvatar(
                radius: 30.0, // Adjust the size of the inner CircleAvatar
                backgroundImage: NetworkImage(nextKeyPoint.images.isNotEmpty
                    ? nextKeyPoint.images[0]
                    : ''),
                backgroundColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
