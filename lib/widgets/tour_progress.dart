import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';
import 'package:latlong2/latlong.dart';

class TourProgressWidget extends StatefulWidget {
  final Tour tour;
  final int nextKeyPointIndex;
  final LatLng currentLocation;

  const TourProgressWidget({
    super.key,
    required this.tour,
    required this.nextKeyPointIndex,
    required this.currentLocation,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TourProgressWidgetState createState() => _TourProgressWidgetState();
}

class _TourProgressWidgetState extends State<TourProgressWidget> {
  String distanceText = '';

  @override
  void didUpdateWidget(covariant TourProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentLocation != oldWidget.currentLocation) {
      updateDistance();
    }
  }

  void updateDistance() {
    if (widget.nextKeyPointIndex < 0 ||
        widget.nextKeyPointIndex >= widget.tour.keyPoints.length) {
      setState(() {
        distanceText = '';
      });
      return;
    }

    LatLng keyPointLocation = widget.tour.getNextKeyPointLocation();
    double distanceInMeters =
        distance(widget.currentLocation, keyPointLocation);

    if (distanceInMeters >= 1000) {
      double distanceInKm = distanceInMeters / 1000;
      setState(() {
        distanceText = '${distanceInKm.toStringAsFixed(1)} km';
      });
    } else {
      setState(() {
        distanceText = '${distanceInMeters.toStringAsFixed(0)} m';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 380,
        height: 100,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: foregroundColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5,
              spreadRadius: 0.1,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next Key Point in $distanceText',
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.tour.keyPoints[widget.nextKeyPointIndex].name,
                    style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 32.0,
              backgroundColor: secondaryColor,
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                  widget.tour.keyPoints[widget.nextKeyPointIndex].images
                          .isNotEmpty
                      ? widget
                          .tour.keyPoints[widget.nextKeyPointIndex].images[0]
                      : '',
                ),
                backgroundColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double distance(LatLng from, LatLng to) {
    return const Distance().as(LengthUnit.Meter, from, to);
  }
}
