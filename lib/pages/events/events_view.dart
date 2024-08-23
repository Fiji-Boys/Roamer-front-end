import 'package:figenie/consts.dart';
import 'package:figenie/model/event.dart';
import 'package:figenie/pages/event_details/event_details_controller.dart';
import 'package:figenie/pages/events/events_controller.dart';
import 'package:figenie/widgets/custom_card.dart';
import 'package:flutter/material.dart';

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
                        final tour = state.filteredEvents[index];
                        return cardUI(context, tour);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardUI(BuildContext context, Event event) {
    return CustomCard(
      name: event.name,
      description: event.description,
      image: event.image,
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
}
