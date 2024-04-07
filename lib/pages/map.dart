import 'dart:async';
import 'dart:math';

import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
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

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Location _locationController = Location();

  List<Tour> tours = <Tour>[];
  late Tour activeTour;
  late bool isTourAcite = false;
  late bool hasStarted = false;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng startLoc = LatLng(45.262610, 19.838718);
  LatLng? currentLoc;

  Map<String, Polyline> currentPolylines = {};

  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;

  Map<String, Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getUserIcon();
    getLocationUpdates();
    getTours();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(currentPolylines.values),
            ),
    );
  }

  Future<void> _getTourMarkers() async {
    for (var tour in tours) {
      final ImageConfiguration imageConfiguration = ImageConfiguration();
      final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/tour_marker.png');
      markers[tour.name] = Marker(
          markerId: MarkerId(tour.name),
          icon: customIcon,
          position: tour.getLocation(),
          onTap: () {
            _showTour(tour);
          });
    }
    setState(() {});
  }

  void _showTour(Tour tour) {
    showKeypoints(tour);
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: AlertDialog(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  "Tour Information",
                  textAlign: TextAlign.center,
                ),
                content: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Tour Name: ${tour.name}"),
                      Text("Tour Description: ${tour.description}"),
                      Text("Number of Key Points: ${tour.keyPoints.length}"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _resetMap();
                        },
                      ),
                      SizedBox(width: 8),
                      TextButton(
                        child: Text("Start Tour"),
                        onPressed: () {
                          hasStarted = true;
                          Navigator.of(context).pop();
                          _startTour(tour);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (!hasStarted) {
        _resetMap();
      }
    });
  }

  void _resetMap() {
    _clearMarkers();
    _clearPolylines();
    _getTourMarkers();
  }

  void showKeypoints(Tour tour) {
    _clearPolylines();
    _clearMarkers();
    for (int i = 0; i < tour.keyPoints.length; i++) {
      markers[tour.keyPoints[i].name] = Marker(
        markerId: MarkerId(tour.keyPoints[i].name),
        icon: BitmapDescriptor.defaultMarker,
        position: tour.keyPoints[i].getLocation(),
        onTap: () {
          _showKeyPoint(tour.keyPoints[i]);
        },
      );
      if (i != tour.keyPoints.length - 1) {
        createPolyline(
          tour.keyPoints[i].getLocation(),
          tour.keyPoints[i + 1].getLocation(),
          "${tour.keyPoints[i].name}/${tour.keyPoints[i + 1].name}",
          secondaryColor,
        );
      }
    }
    setState(() {});
  }

  void _startTour(Tour selectedTour) {
    activeTour = selectedTour;
    activeTour.startTour();
    isTourAcite = true;
    createPolyline(currentLoc!, selectedTour.getNextKeyPointLocation(), "user",
        primaryColor);
  }

  void _showKeyPoint(KeyPoint kp) {
    // Ovde nesto da se desi kada se stisne keypoint
  }

  void _clearMarkers() {
    markers.clear();
    markers["_currentLocation"] = Marker(
        markerId: const MarkerId("_currentLocation"),
        icon: userIcon,
        position: currentLoc!,
        zIndex: 100);
  }

  void _clearPolylines() {
    currentPolylines.clear();
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
          latitude: 45.246618,
          longitude: 19.851681)
    ];

    Tour newTour = Tour(
        name: "TestTour", description: "TestDescription", keyPoints: keyPoints);
    tours.add(newTour);
    _getTourMarkers();
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
          if (isTourAcite) {
            if (calculateDistance()) {
              deleteRoute(activeTour.keyPoints[activeTour.nextKeyPoint].name,
                  activeTour.keyPoints[activeTour.nextKeyPoint + 1].name);
              activeTour.completeKeyPoint();
            }

            createPolyline(currentLoc!, activeTour.getNextKeyPointLocation(),
                "user", primaryColor);
          }
          markers["_currentLocation"] = Marker(
              markerId: const MarkerId("_currentLocation"),
              icon: userIcon,
              position: currentLoc!,
              zIndex: 100);
        });
      }
    });
  }

  void createPolyline(LatLng source, LatLng dest, String polylineId,
      Color polyLineColor) async {
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
        currentPolylines[polylineId] = Polyline(
            polylineId: PolylineId(polylineId),
            points: polylineCoords,
            width: 6,
            color: polyLineColor);
      });
    }
  }

  void getUserIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/user_marker.png")
        .then(
      (icon) {
        setState(() {
          userIcon = icon;
        });
      },
    );
  }

  bool calculateDistance() {
    var p = 0.017453292519943295;
    var c = cos;
    LatLng nextKeyPointLocation = activeTour.getNextKeyPointLocation();
    var a = 0.5 -
        c((nextKeyPointLocation.latitude - currentLoc!.latitude) * p) / 2 +
        c(currentLoc!.latitude * p) *
            c(nextKeyPointLocation.latitude * p) *
            (1 -
                c((nextKeyPointLocation.longitude - currentLoc!.longitude) *
                    p)) /
            2;
    double distance = 1000 * 12742 * asin(sqrt(a));
    debugPrint(distance.toString());
    return distance < 50;
  }

  void deleteRoute(String currentKeyPoint, String nextKeyPoint) {
    currentPolylines.remove("$currentKeyPoint/$nextKeyPoint");
    markers.remove(currentKeyPoint);
  }
}
