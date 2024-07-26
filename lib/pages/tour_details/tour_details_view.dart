import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/pages/tour_details/tour_details_controller.dart';
import 'package:figenie/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
            descriptionUI(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: state.tour.keyPoints.length,
                itemBuilder: (context, index) {
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
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: textColor,
                      size: 12.0,
                    ),
                    const SizedBox(width: 8.0),
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
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Points: ${state.tour.points}',
                  style: const TextStyle(
                    color: secondaryDarkColor,
                    fontSize: 13.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget descriptionUI() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description:",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            state.tour.description,
            style: const TextStyle(
              fontSize: 16.0,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget cardUI(BuildContext context, KeyPoint keyPoint) {
    return CustomCard(
      name: keyPoint.name,
      description: keyPoint.description,
      image: keyPoint.images[0],
      onTap: () {},
      showArrow: false,
    );
  }
}
