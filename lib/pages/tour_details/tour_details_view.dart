import 'package:figenie/pages/tour_details/tour_details_controller.dart';
import 'package:flutter/material.dart';

class TourDetailsView extends StatelessWidget {
  final TourDetailController state;
  const TourDetailsView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        width: double.infinity,
        height: double.infinity,
        child: const Center(
          child: Placeholder(),
        ),
      ),
    );
  }
}
