import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/pages/event_details/event_details_controller.dart';
import 'package:figenie/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/event.dart';

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
            const SizedBox(height: 16.0),
            descriptionUI(),
            Container(
              margin: const EdgeInsets.only(top: 16.0, right: 8.0),
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(0),
                  ),
                ),
                child: const Text(
                  'Show on Map',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ),
            ),
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
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1.0, 1.0),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: isOngoing(state.event) ? secondaryColor : textColor,
                    size: 12.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    getTimeUntilEvent(
                        state.event.startDate, state.event.endDate),
                    style: TextStyle(
                      color:
                          isOngoing(state.event) ? secondaryColor : textColor,
                      fontSize: 16.0,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget descriptionUI() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
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

  bool isOngoing(Event event) {
    final now = DateTime.now();
    return now.isAfter(event.startDate) && now.isBefore(event.endDate);
  }

  String getTimeUntilEvent(
      DateTime eventStartDateTime, DateTime eventEndDateTime) {
    DateTime now = DateTime.now();
    Duration timeUntilStart = eventStartDateTime.difference(now);
    Duration timeUntilEnd = eventEndDateTime.difference(now);

    if (now.isBefore(eventStartDateTime)) {
      if (timeUntilStart.inDays > 1) {
        return "Event starts on ${DateFormat('dd.MM.yyyy.').format(eventStartDateTime)}";
      } else if (timeUntilStart.inDays == 1) {
        return "Event starts tomorrow";
      } else if (timeUntilStart.inHours > 0) {
        return "Starts in ${timeUntilStart.inHours} hours";
      } else {
        return "Starts today";
      }
    } else if (now.isBefore(eventEndDateTime)) {
      if (timeUntilEnd.inDays > 1) {
        return "Ongoing, ends in ${timeUntilEnd.inDays} days";
      } else if (timeUntilEnd.inDays == 1) {
        return "Ongoing, ends tomorrow";
      } else if (timeUntilEnd.inHours > 24) {
        return "Ongoing, ends in ${timeUntilEnd.inDays} days";
      } else {
        return "Ongoing, ends in ${timeUntilEnd.inHours} hours";
      }
    } else {
      return "Ended on ${DateFormat('dd.MM.yyyy.').format(eventEndDateTime)}";
    }
  }

  Widget cardUI(BuildContext context, KeyPoint keyPoint) {
    return CustomCard(
      name: keyPoint.name,
      description: keyPoint.description,
      image: keyPoint.images.isNotEmpty ? keyPoint.images[0] : '',
      onTap: () {},
      showArrow: false,
    );
  }
}
