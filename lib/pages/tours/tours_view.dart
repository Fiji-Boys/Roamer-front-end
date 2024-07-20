import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/tours/tours_controller.dart';
import 'package:flutter/material.dart';

class ToursView extends StatelessWidget {
  final ToursController state;
  const ToursView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: foregroundColor,
      child: ListView.builder(
        itemCount: state.tours.length,
        itemBuilder: (context, index) {
          final tour = state.tours[index];
          return cardUI(tour);
        },
      ),
    );
  }

  Widget cardUI(Tour tour) {
    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                tour.keyPoints[0].images[0],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
              child: SizedBox(
            height: 110,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      tour.name,
                      style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    tour.description,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          )),
          const Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.keyboard_arrow_right,
              color: textColor,
              size: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
