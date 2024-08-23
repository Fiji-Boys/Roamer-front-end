import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/tour_details/tour_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:figenie/model/user.dart' as model_user;

class TourCard extends StatelessWidget {
  final model_user.User user;
  final Tour tour;

  const TourCard({
    required this.tour,
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TourDetailsPage(tour: tour, user: user)),
        );
      },
      child: Container(
        // color: foregroundColor,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: foregroundColorDarker,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  tour.keyPoints[0].images[0],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 70,
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
