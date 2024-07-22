import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/tour_details/tour_details_controller.dart';
import 'package:figenie/pages/tours/tours_controller.dart';
import 'package:flutter/material.dart';

class ToursView extends StatelessWidget {
  final ToursController state;
  const ToursView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: foregroundColor,
          child: Column(children: [
            searchBarUI(),
            Expanded(
              child: ListView.builder(
                itemCount: state.tours.length,
                itemBuilder: (context, index) {
                  final tour = state.tours[index];
                  return cardUI(context, tour);
                },
              ),
            )
          ])),
    );
  }

  Widget searchBarUI() {
    return const Placeholder();
    // return Padding(
    //   padding: const EdgeInsets.all(16.0),
    //   child: Container(
    //     decoration: BoxDecoration(
    //       color: backgroundColor, // Use your desired background color
    //       borderRadius: BorderRadius.circular(8.0), // Set the border radius
    //     ),
    //     child: const Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 16.0),
    //       child: TextField(
    //         decoration: InputDecoration(
    //           hintText: 'Search',
    //           border: InputBorder.none,
    //           icon: Icon(
    //             Icons.search,
    //             color: textColor, // Use your desired icon color
    //           ),
    //         ),
    //         style: TextStyle(
    //           color: textColor, // Use your desired text color
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget cardUI(BuildContext context, Tour tour) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TourDetailsPage(tour: tour),
          ),
        );
      },
      child: Card(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tour.name,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        tour.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                          color: textLightColor,
                          fontSize: 14.0,
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
