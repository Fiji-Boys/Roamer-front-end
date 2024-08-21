import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/tour_details/tour_details_controller.dart';
import 'package:flutter/material.dart';

class TourCard extends StatelessWidget {
  final Tour tour;

  const TourCard({
    required this.tour,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TourDetailsPage(tour: tour, showOnMap: (p0) {
              
            },),
          ),
        );
      },
      child: Container(
        // color: foregroundColor,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: foregroundColorLighter,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(190, 0, 0, 0),
              blurRadius: 5,
              spreadRadius: 0.1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  tour.keyPoints[0].images[0],
                  width: 80,
                  height: 80,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tour.name,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
      ),
    );
  }
}
