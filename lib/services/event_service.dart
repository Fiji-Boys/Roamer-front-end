import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figenie/model/event.dart';

class EventService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _events;

  EventService() {
    _events = _firestore.collection("events").withConverter<Event>(
        fromFirestore: (snapshots, _) => Event.fromJson(snapshots.data()!),
        toFirestore: (tour, _) => tour.toJson());
  }

  Future<List<Event>> getAll() async {
    QuerySnapshot querySnapshot = await _events.get();
    final List<Event> events = [];

    for (var doc in querySnapshot.docs) {
      events.add(doc.data() as Event);
    }

    return events;
  }

  // void pushEvents() {
  //   final event1 = Event(
  //     id: '1',
  //     name: 'Novi Sad Jazz Festival',
  //     description:
  //         'An annual jazz festival featuring local and international jazz musicians.',
  //     longitude: 19.8373,
  //     latitude: 45.2552,
  //     type: EventType.music,
  //     startDate: DateTime(2024, 10, 15, 18, 0),
  //     endDate: DateTime(2024, 10, 18, 23, 0),
  //   );

  //   final event2 = Event(
  //     id: '2',
  //     name: 'Danube Marathon',
  //     description:
  //         'A marathon along the Danube river, attracting runners from around the world.',
  //     longitude: 19.8395,
  //     latitude: 45.2561,
  //     type: EventType.sport,
  //     startDate: DateTime(2024, 9, 10, 7, 0),
  //     endDate: DateTime(2024, 9, 10, 15, 0),
  //   );

  //   final event3 = Event(
  //     id: '3',
  //     name: 'EXIT Festival',
  //     description:
  //         'A famous summer music festival held at the Petrovaradin Fortress.',
  //     longitude: 19.8610,
  //     latitude: 45.2497,
  //     type: EventType.music,
  //     startDate: DateTime(2024, 7, 4, 16, 0),
  //     endDate: DateTime(2024, 7, 7, 2, 0),
  //   );

  //   final event4 = Event(
  //     id: '4',
  //     name: 'Winter Magic Market',
  //     description:
  //         'A winter market with festive booths, food, and entertainment for all ages.',
  //     longitude: 19.8405,
  //     latitude: 45.2573,
  //     type: EventType.market,
  //     startDate: DateTime(2024, 12, 15, 10, 0),
  //     endDate: DateTime(2024, 12, 25, 22, 0),
  //   );

  //   final event5 = Event(
  //     id: '5',
  //     name: 'Art Exhibition at Gallery of Matica Srpska',
  //     description:
  //         'A contemporary art exhibition showcasing works of local artists.',
  //     longitude: 19.8442,
  //     latitude: 45.2585,
  //     type: EventType.art,
  //     startDate: DateTime(2024, 11, 5, 9, 0),
  //     endDate: DateTime(2024, 11, 15, 17, 0),
  //   );

  //   // List of events to push
  //   final events = [event1, event2, event3, event4, event5];

  //   // Add each event to the Firestore collection
  //   for (var event in events) {
  //     _events.add(event);
  //   }
  // }
}
