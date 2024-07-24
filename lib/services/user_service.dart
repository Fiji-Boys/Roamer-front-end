import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figenie/model/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<User> _users;

  UserService() {
    _users = _firestore.collection("users").withConverter<User>(
        fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson());
  }

  Future<void> saveUser(User user) async {
    try {
      bool exists = await _checkUserExists(user.id);
      if (!exists) {
        await _users.doc(user.id).set(user);
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
}
