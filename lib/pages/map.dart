import 'dart:async';

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
  late Tour tour;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng startLoc = LatLng(45.262610, 19.838718);
  static const LatLng destLoc = LatLng(45.261735, 19.856769);
  LatLng? currentLoc;

  Map<PolylineId, Polyline> polylines = {};

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    getUserIcon();
    getLocationUpdates();
    getPolyPoints();
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
              markers: {
                Marker(
                    markerId: const MarkerId("_currentLocation"),
                    icon: markerIcon,
                    position: currentLoc!,
                    zIndex: 100),
                const Marker(
                    markerId: MarkerId("_sourceLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: startLoc),
                const Marker(
                    markerId: MarkerId("_destionationLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: destLoc)
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  void startTour() {
    List<KeyPoint> keyPoints = [
      KeyPoint(
          id: 1,
          name: "KeyPoint1",
          description: "Description of Key Point 1",
          images: ["image1.jpg", "image2.jpg"],
          latitude: 45.262610,
          longitude: 19.838718),
      KeyPoint(
          id: 1,
          name: "KeyPoint2",
          description: "Description of Key Point 2",
          images: ["image3.jpg", "image4.jpg"],
          latitude: 45.262610,
          longitude: 19.856769),
      KeyPoint(
          id: 1,
          name: "KeyPoint3",
          description: "Description of Key Point 3",
          images: ["image5.jpg", "image6.jpg"],
          latitude: 45.247218,
          longitude: 19.853681)
    ];
    tour = Tour(
        name: "TestTure", description: "TestDescription", keyPoints: keyPoints);
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
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

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentLoc =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapsApiKey,
        PointLatLng(startLoc.latitude, startLoc.longitude),
        PointLatLng(destLoc.latitude, destLoc.longitude),
        travelMode: TravelMode.walking);

    List<LatLng> polylineCoords = [];

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {
        polylines[const PolylineId("route")] = Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoords,
            width: 6,
            color: primaryColor);
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

  // Future<List<LatLng>> getPolylinePoints() async {
  //   List<LatLng> polylineCoordinates = [];
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     GOOGLE_MAPS_API_KEY,
  //     PointLatLng(startingPos.latitude, startingPos.longitude),
  //     PointLatLng(destPos.latitude, destPos.longitude),
  //     travelMode: TravelMode.driving,
  //   );
  //   if (result.points.isNotEmpty) {
  //     for (var point in result.points) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     }
  //   } else {
  //     print(result.errorMessage);
  //   }
  //   return polylineCoordinates;
  // }

  // void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
  //   PolylineId id = const PolylineId("poly");
  //   Polyline polyline = Polyline(
  //       polylineId: id,
  //       color: Colors.black,
  //       points: polylineCoordinates,
  //       width: 8);
  //   setState(() {
  //     polylines[id] = polyline;
  //   });
  // }
}
