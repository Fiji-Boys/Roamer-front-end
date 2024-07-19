import 'package:figenie/consts.dart';
import 'package:figenie/pages/tour_details/tour_details_controller.dart';
import 'package:flutter/material.dart';

class TourDetailsView extends StatelessWidget {
  final TourDetailController state;
  const TourDetailsView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    final tour = state.tour;

    return Scaffold(
      backgroundColor: foregroundColor,
      body: Container(
        color: foregroundColor,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.35,
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Stack(
            children: [
              // Positioned image with opacity
              Positioned.fill(
                child: Opacity(
                  opacity: 0.7,
                  child: Image.network(
                    tour.keyPoints[0].images[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Centered text with tour name
              Center(
                child: Text(
                  tour.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Positioned location logo and keypoints info at the bottom left
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Location icon
                      const Icon(
                        Icons.location_on,
                        color: textColor,
                        size: 12.0,
                      ),
                      const SizedBox(width: 8.0),
                      // Number of keypoints text
                      Text(
                        'Number of keypoints: ${tour.keyPoints.length}',
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
