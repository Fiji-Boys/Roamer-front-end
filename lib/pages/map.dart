import 'dart:async';
import 'dart:ffi';

import 'package:figenie/consts.dart';
import 'package:figenie/model/keyPoint.dart';
import 'package:figenie/model/tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();

  List<Tour> tours = <Tour>[];
  late Tour activeTour;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng startLoc = LatLng(45.262610, 19.838718);
  LatLng? currentLoc;

  List<Polyline> currentPolylines = <Polyline>[];

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  List<Marker> markers = <Marker>[];

  @override
  void initState() {
    super.initState();
    getUserIcon();
    getLocationUpdates();
    getTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLoc == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: const CameraPosition(
                target: startLoc,
                zoom: 13,
              ),
              markers: markers.toSet(),
              polylines: currentPolylines.toSet(),
            ),
    );
  }

  void _getTourMarkers() {
    for (var tour in tours) {
      markers.add(Marker(
          markerId: MarkerId(tour.name),
          icon: BitmapDescriptor.defaultMarker,
          position: tour.getLocation(),
          onTap: () {
            _showTour(tour);
          }));
    }
    setState(() {});
  }

  void _showTour(Tour tour) {
    _clearPolylines();
    _clearMarkers();
    for (int i = 0; i < tour.keyPoints.length; i++) {
      markers.add(Marker(
          markerId: MarkerId(tour.keyPoints[i].name),
          icon: BitmapDescriptor.defaultMarker,
          position: tour.keyPoints[i].getLocation(),
          onTap: () {
            _showKeyPoint(tour.keyPoints[i]);
          }));
      if (i != tour.keyPoints.length - 1) {
        createPolyline(
            tour.keyPoints[i].getLocation(),
            tour.keyPoints[i + 1].getLocation(),
            "${tour.keyPoints[i].name}/${tour.keyPoints[i + 1].name}");
      }
    }
    setState(() {});
  }

  void _showKeyPoint(KeyPoint kp) {
    // Ovde nesto da se desi kada se stisne keypoint
  }

  void _clearMarkers() {
    markers = [
      Marker(
          markerId: const MarkerId("_currentLocation"),
          icon: markerIcon,
          position: currentLoc!,
          zIndex: 100)
    ];
  }

  void _clearPolylines() {
    if (currentPolylines.isNotEmpty) {
      currentPolylines = [currentPolylines.first];
    }
  }

  void getTours() {
    List<KeyPoint> keyPoints = [
      KeyPoint(
          id: 1,
          name: "KeyPoint1",
          description: "Description of Key Point 1",
          images: ["image1.jpg", "image2.jpg"],
          latitude: 45.262610,
          longitude: 19.838718),
      KeyPoint(
          id: 2,
          name: "KeyPoint2",
          description: "Description of Key Point 2",
          images: ["image3.jpg", "image4.jpg"],
          latitude: 45.262610,
          longitude: 19.856769),
      KeyPoint(
          id: 3,
          name: "KeyPoint3",
          description: "Description of Key Point 3",
          images: ["image5.jpg", "image6.jpg"],
          latitude: 45.247218,
          longitude: 19.853681)
    ];
    Tour newTour = Tour(
        name: "TestTour", description: "TestDescription", keyPoints: keyPoints);
    tours.add(newTour);
    _getTourMarkers();
  }

  void startTour(Tour selectedTour) {
    activeTour = selectedTour;
    activeTour.startTour();
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    bool hasLocationChanged = false;

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentLoc =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (!hasLocationChanged) {
            markers.add(Marker(
                markerId: const MarkerId("_currentLocation"),
                icon: markerIcon,
                position: currentLoc!,
                zIndex: 100));
            hasLocationChanged = true;
          }
        });
      }
    });
  }

  void createPolyline(LatLng source, LatLng dest, String polylineId) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapsApiKey,
        PointLatLng(source.latitude, source.longitude),
        PointLatLng(dest.latitude, dest.longitude),
        travelMode: TravelMode.walking);

    List<LatLng> polylineCoords = [];

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {
        currentPolylines.add(Polyline(
            polylineId: PolylineId(polylineId),
            points: polylineCoords,
            width: 6,
            color: primaryColor));
      });
    }
  }

  void getUserIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/user_marker.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }
}