import 'dart:developer' as dev;
import 'package:figenie/model/user.dart' as model_user;
import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/tours/tours_view.dart';
import 'package:figenie/services/tour_service.dart';
import 'package:figenie/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ToursPage extends StatefulWidget {
  const ToursPage({super.key});

  @override
  State<ToursPage> createState() => ToursController();
}

final TourService service = TourService();

class ToursController extends State<ToursPage>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController searchController;
  List<Tour> tours = [];
  List<Tour> filteredTours = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late model_user.User user;
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ToursView(this);
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getTours();
    setUser();
  }

  Future<void> setUser() async {
    if (_auth.currentUser != null) {
      try {
        user = await userService.getCurrentUser();
      } catch (e) {
        dev.log(e.toString(), name: "GetCurrentUser");
      }
    }
  }

  void getTours() async {
    final tourList = await service.getAll();
    setState(() {
      tours = tourList;
      filteredTours = tours;
    });
  }

  void setTours(tourList) {
    setState(() {
      filteredTours = tourList;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
