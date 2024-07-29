import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/tour_details/tour_details_view.dart';
import 'package:flutter/material.dart';

class TourDetailsPage extends StatefulWidget {
  final Tour tour;
  const TourDetailsPage({super.key, required this.tour});

  @override
  State<TourDetailsPage> createState() => TourDetailController();
}

class TourDetailController extends State<TourDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return TourDetailsView(this);
  }

  late final Tour tour;

  @override
  void initState() {
    super.initState();
    tour = widget.tour;
  }
}
