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
              // Container for the image
              Positioned.fill(
                child: Image.network(
                  tour.keyPoints[0].images[0],
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(.7),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
