import 'package:figenie/pages/events/events_view.dart';
import 'package:figenie/services/event_service.dart';
import 'package:flutter/material.dart';

import '../../model/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => EventsController();
}

final EventService service = EventService();

class EventsController extends State<EventsPage>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController searchController;
  List<Event> events = [];
  List<Event> filteredEvents = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EventsView(this);
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getEvents();
  }

  void getEvents() async {
    final eventList = await service.getAll();
    setState(() {
      events = eventList;
      filteredEvents = eventList;
    });
  }

  void setEvents(eventList) {
    setState(() {
      filteredEvents = eventList;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
