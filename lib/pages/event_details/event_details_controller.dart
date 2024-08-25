import 'package:figenie/model/event.dart';
import 'package:figenie/pages/event_details/event_details_view.dart';
import 'package:flutter/material.dart';

class EventDetailsPage extends StatefulWidget {
  // final Function(String) showOnMap;
  final Event event;

  const EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsPage> createState() => EventDetailController();
}

class EventDetailController extends State<EventDetailsPage> {
  late final Event event;

  @override
  void initState() {
    super.initState();
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    return EventDetailsView(this);
  }
}
