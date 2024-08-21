import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/tour_details/tour_details_view.dart';
import 'package:flutter/material.dart';

class TourDetailsPage extends StatefulWidget {
  final Tour tour;
  final void Function(String) showOnMap;

  const TourDetailsPage(
      {super.key, required this.tour, required this.showOnMap});

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

  void onShowOnMap() {
    Navigator.pop(context);
    widget.showOnMap(tour.name);
  }
}
