import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/pages/tour_details/tour_details_controller.dart';
import 'package:flutter/material.dart';

class TourDetailsView extends StatelessWidget {
  final TourDetailController state;
  const TourDetailsView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: foregroundColor,
        child: Column(
          children: [
            headerUI(context),
            Expanded(
              child: ListView.builder(
                itemCount: state.tour.keyPoints.length,
                itemBuilder: (context, index) {
                  print(state.tour.keyPoints.length);
                  final keyPoint = state.tour.keyPoints[index];
                  return cardUI(context, keyPoint);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerUI(BuildContext context) {
    final String imageUrl = state.tour.keyPoints.isNotEmpty &&
            state.tour.keyPoints[0].images.isNotEmpty
        ? state.tour.keyPoints[0].images[0]
        : '';

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Stack(
          children: [
            // Positioned image with opacity
            if (imageUrl.isNotEmpty)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.7,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            // Centered text with tour name
            Center(
              child: Text(
                state.tour.name,
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
                      'Number of keypoints: ${state.tour.keyPoints.length}',
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardUI(BuildContext context, KeyPoint keyPoint) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => TourDetailsPage(ke: tour),
        //   ),
        // );
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
                  keyPoint.images[0],
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
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        keyPoint.name,
                        style: const TextStyle(
                          color: secondaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        keyPoint.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                          color: textColor,
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
