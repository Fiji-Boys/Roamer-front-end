import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/tour_details/tour_details_view.dart';
import 'package:flutter/material.dart';

class TourDetailsPage extends StatefulWidget {
  // final Function(String) showOnMap;
  final Tour tour;

  const TourDetailsPage({
    super.key,
    required this.tour,
  });

  @override
  State<TourDetailsPage> createState() => TourDetailController();
}

class TourDetailController extends State<TourDetailsPage> {
  late final Tour tour;

  @override
  void initState() {
    super.initState();
    tour = widget.tour;
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
