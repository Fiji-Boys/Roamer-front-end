import 'package:figenie/pages/tours/tours_controller.dart';
import 'package:flutter/material.dart';

class ToursView extends StatelessWidget {
  final ToursController state;
  const ToursView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green, // Set the background color to green
      child: const Placeholder(), // Replace with your actual content
    );
  }
}
