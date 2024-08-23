import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/pages/event_details/event_details_controller.dart';
import 'package:figenie/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class EventDetailsView extends StatelessWidget {
  final EventDetailController state;
  const EventDetailsView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: foregroundColor,
        child: Column(
          children: [
            headerUI(context),
            descriptionUI(),
          ],
        ),
      ),
    );
  }

  Widget headerUI(BuildContext context) {
    final String imageUrl =
        state.event.image.isNotEmpty ? state.event.image : '';

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
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
          // Back arrow button
          Positioned(
            top: 25.0,
            left: 0.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: textColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.event.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                // showOnMapButton(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showOnMapButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pop(context);
        // state.onShowOnMap();
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: secondaryColor,
        side: const BorderSide(
          color: secondaryColor,
          width: 2.0,
        ),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      child: const Text(
        'Show on Map',
        style: TextStyle(
          color: secondaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget descriptionUI() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerLeft, // Ensure content is aligned to the left
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the start (left)
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
            state.event.description,
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
