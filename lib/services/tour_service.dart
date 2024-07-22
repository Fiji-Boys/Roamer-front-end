import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/model/tour.dart';

class TourService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _tours;

  TourService() {
    _tours = _firestore.collection("tours").withConverter<Tour>(
        fromFirestore: (snapshots, _) => Tour.fromJson(snapshots.data()!),
        toFirestore: (tour, _) => tour.toJson());
  }

  Future<List<Tour>> getAll() async {
    QuerySnapshot querySnapshot = await _tours.get();
    final List<Tour> tours = [];

    for (var doc in querySnapshot.docs) {
      QuerySnapshot keyPointsSnapshot = await doc.reference
          .collection('keyPoints')
          .withConverter(
            fromFirestore: (snapshots, _) =>
                KeyPoint.fromJson(snapshots.data()!),
            toFirestore: (keypoint, _) => keypoint.toJson(),
          )
          .orderBy("order")
          .get();
      List<KeyPoint> keyPoints = keyPointsSnapshot.docs
          .map((kpDoc) => kpDoc.data() as KeyPoint)
          .toList();

      Tour tour = doc.data() as Tour;

      tour.keyPoints = keyPoints;
      tours.add(tour);
    }

    return tours;
  }
}
