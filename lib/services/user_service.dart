import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/model/user.dart' as fiji_user;
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<fiji_user.User> _users;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  UserService() {
    _users = _firestore.collection("users").withConverter<fiji_user.User>(
        fromFirestore: (snapshots, _) =>
            fiji_user.User.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson());

    currentUser = _auth.currentUser;

    _auth.userChanges().listen((event) {
      currentUser = event;
    });
  }

  Future<void> saveUser(fiji_user.User user) async {
    try {
      bool exists = await _checkUserExists(user.id);
      if (!exists) {
        await _users.doc(user.id).set(user);
      } else {
        fiji_user.User existingUser = await getCurrentUser();
        existingUser.username = user.username;
        existingUser.profilePicture = user.profilePicture;
        await _users.doc(user.id).set(existingUser);
      }
    } catch (e) {
      throw Exception('Error saving user: $e');
    }
  }

  Future<bool> _checkUserExists(String userId) async {
    try {
      var doc = await _users.doc(userId).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Error checking if user exists: $e');
    }
  }

  Future<fiji_user.User> getCurrentUser() async {
    final DocumentSnapshot<fiji_user.User> doc =
        await _users.doc(currentUser!.uid).get();
    List<Tour> tours = await getCompletedTours(currentUser!.uid);

    fiji_user.User user = doc.data() as fiji_user.User;
    user.completedTours = tours;

    return user;
  }

  Future<void> completeTour(
      fiji_user.User currentUser, Tour selectedTour) async {
    currentUser.completedTours.add(selectedTour);
    currentUser.points += selectedTour.points;

    DocumentReference userRef =
        _firestore.collection('users').doc(currentUser.id);

    DocumentReference userCompletedTourRef = userRef
        .collection("completedTours")
        .withConverter<Tour>(
            fromFirestore: (snapshots, _) => Tour.fromJson(snapshots.data()!),
            toFirestore: (tour, _) => tour.toJson())
        .doc(selectedTour.id);

    try {
      await userCompletedTourRef.set(selectedTour);
      for (var keyPoint in selectedTour.keyPoints) {
        await userCompletedTourRef
            .collection("keyPoints")
            .add(keyPoint.toJson());
      }
      await userRef.update(
        {"points": currentUser.points},
      );
    } catch (e) {
      log(e.toString(), name: "Complete Tour");
    }
  }

  Future<List<Tour>> getCompletedTours(String id) async {
    CollectionReference tours0 = _firestore
        .collection("users")
        .doc(id)
        .collection("completedTours")
        .withConverter<Tour>(
            fromFirestore: (snapshots, _) => Tour.fromJson(snapshots.data()!),
            toFirestore: (tour, _) => tour.toJson());

    QuerySnapshot querySnapshot = await tours0.get();
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
