import 'package:figenie/consts.dart';
import 'package:figenie/model/event.dart';
import 'package:figenie/pages/event_details/event_details_controller.dart';
import 'package:figenie/pages/events/events_controller.dart';
import 'package:figenie/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsView extends StatelessWidget {
  final EventsController state;
  const EventsView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: foregroundColor,
        child: Column(
          children: [
            Expanded(
              child: state.filteredEvents.isEmpty
                  ? const Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(secondaryColor),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: state.filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = state.filteredEvents[index];
                        return cardUI(context, event);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardUI(BuildContext context, Event event) {
    String statusMessage = getTimeUntilEvent(event.startDate, event.endDate);
    Color statusColor = getStatusColor(event.startDate, event.endDate);

    return CustomCard(
      name: event.name,
      description: statusMessage,
      image: event.image,
      statusColor: statusColor, // Adding status color
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(
                event: event,
              ),
            ));
      },
      showArrow: true,
    );
  }

  String getTimeUntilEvent(
      DateTime eventStartDateTime, DateTime eventEndDateTime) {
    DateTime now = DateTime.now();

    // Get difference in days between event start and now
    int differenceInDays = eventStartDateTime.difference(now).inDays;

    // If the event hasn't started yet
    if (differenceInDays > 1) {
      return "Starts in $differenceInDays days";
    } else if (differenceInDays == 1) {
      return "Starts tomorrow";
    } else if (differenceInDays == 0) {
      // Check if it starts today and calculate hours
      int differenceInHours = eventStartDateTime.difference(now).inHours;
      if (differenceInHours > 0) {
        return "Starts in $differenceInHours hours";
      } else {
        // If the event is ongoing, calculate how many hours until it ends
        int remainingHours = eventEndDateTime.difference(now).inHours;
        if (remainingHours > 24) {
          int remainingDays = (remainingHours / 24).floor();
          return "Event is ongoing, ends in $remainingDays days";
        } else if (remainingHours > 0) {
          return "Event is ongoing, ends in $remainingHours hours";
        } else {
          // If the event has already ended today, show the end time
          String formattedEndDateTime =
              DateFormat('HH:mm').format(eventEndDateTime);
          return "Event has already ended at $formattedEndDateTime today";
        }
      }
    }

    // If the event has already started and is ongoing across multiple days
    if (now.isAfter(eventStartDateTime) && now.isBefore(eventEndDateTime)) {
      int remainingHours = eventEndDateTime.difference(now).inHours;
      if (remainingHours > 24) {
        int remainingDays = (remainingHours / 24).floor();
        return "Event is ongoing, ends in $remainingDays days";
      }
      String formattedEndDateTime =
          DateFormat('dd-MM-yyyy HH:mm').format(eventEndDateTime);
      return "Event is ongoing, ends at $formattedEndDateTime";
    }

    // If the event has already ended
    String formattedEndDateTime =
        DateFormat('dd-MM-yyyy HH:mm').format(eventEndDateTime);
    return "Event has already ended at $formattedEndDateTime";
  }

  // Helper method to determine the color based on event status
  Color getStatusColor(DateTime eventStartDateTime, DateTime eventEndDateTime) {
    DateTime now = DateTime.now();

    if (now.isBefore(eventStartDateTime)) {
      return Colors.grey;
    } else if (now.isAfter(eventEndDateTime)) {
      return errorColor;
    } else if (now.isAfter(eventStartDateTime) &&
        now.isBefore(eventEndDateTime)) {
      return secondaryColor;
    } else if (eventStartDateTime.difference(now).inHours <= 1) {
      return primaryColor;
    }

    return primaryColor; // Default color for other cases
  }
}
