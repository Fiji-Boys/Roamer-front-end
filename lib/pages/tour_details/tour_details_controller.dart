import 'package:figenie/model/tour.dart';
import 'package:figenie/model/user.dart' as model_user;
import 'package:figenie/pages/tour_details/tour_details_view.dart';
import 'package:flutter/material.dart';

class TourDetailsPage extends StatefulWidget {
  // final Function(String) showOnMap;
  final model_user.User user;
  final Tour tour;

  const TourDetailsPage({
    super.key,
    required this.tour,
    required this.user,
  });

  @override
  State<TourDetailsPage> createState() => TourDetailController();
}

class TourDetailController extends State<TourDetailsPage> {
  late final Tour tour;
  late final model_user.User user;

  @override
  void initState() {
    super.initState();
    tour = widget.tour;
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return TourDetailsView(this);
  }

  // void onShowOnMap() {
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     widget.showOnMap(tour.name);
  //   });
  // }
}
