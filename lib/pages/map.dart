// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/widgets/key_poin_modal.dart';
import 'package:figenie/widgets/weather_info.dart';
import 'package:figenie/widgets/loading.dart';
import 'package:figenie/widgets/tour_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

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
  Tour? selectedTour;
  late bool isTourActive = false;
  late bool hasStarted = false;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng startLoc = LatLng(45.262501, 19.839263);
  LatLng? currentLoc;
  Map<String, Polyline> currentPolylines = {};
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;
  Map<String, Marker> markers = {};

  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    getUserIcon();
    getLocationUpdates();
    getTours();
    valueNotifier = ValueNotifier(0.0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        _resetMap();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            currentLoc == null
                ? const Center(
                    child: Loading(),
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
                    compassEnabled: false,
                    zoomControlsEnabled: false,
                  ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 7.0), // Adjust the value for the top margin as needed
              child: Align(
                alignment:
                    Alignment.topLeft, // Align to the top-left of the Stack
                child: currentLoc != null
                    ? WeatherInfo(
                        currentLoc:
                            currentLoc!) // Show weather menu if location is available
                    : Container(
                        color: primaryContentColor,
                        height: 50.0, // Assign a fixed height to the container
                        // Add more properties if needed
                      ),
              ),
            ),
            selectedTour == null
                ? Container()
                : TourInfo(
                    tour: selectedTour!,
                    onStartTour: _startTour,
                    valueNotifier: valueNotifier,
                  ),
            selectedTour != null
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        backgroundColor: foregroundColor,
                        foregroundColor: textColor,
                        child: const Icon(Icons.close),
                        onPressed: () {
                          if (isTourActive) {
                            _showAbandonModal();
                          } else {
                            _resetMap();
                          }
                        },
                      ),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  Future<void> _getTourMarkers() async {
    for (var tour in tours) {
      markers[tour.name] = Marker(
          markerId: MarkerId(tour.name),
          icon: await getLocationIcon("orange"),
          position: tour.getLocation(),
          onTap: () {
            _showTour(tour);
          });
    }
    setState(() {});
  }

  void _showTour(Tour tour) {
    showKeypoints(tour);
    _centerMapToBounds(tour.keyPoints);
  }

  void _centerMapToBounds(List<KeyPoint> keyPoints) {
    if (keyPoints.isEmpty) return;

    double minLat = keyPoints.first.latitude;
    double maxLat = keyPoints.first.latitude;
    double minLng = keyPoints.first.longitude;
    double maxLng = keyPoints.first.longitude;

    for (final keyPoint in keyPoints) {
      minLat = min(minLat, keyPoint.latitude);
      maxLat = max(maxLat, keyPoint.latitude);
      minLng = min(minLng, keyPoint.longitude);
      maxLng = max(maxLng, keyPoint.longitude);
    }

    final southWest = LatLng(minLat, minLng);
    final northEast = LatLng(maxLat, maxLng);

    final bounds = LatLngBounds(southwest: southWest, northeast: northEast);

    _mapController.future.then((controller) {
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 130));
    });
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(
          color: secondaryColor,
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      width: 300,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _resetMap() {
    selectedTour = null;
    _clearMarkers();
    _clearPolylines();
    _getTourMarkers();
  }

  Future<void> showKeypoints(Tour tour) async {
    _clearPolylines();
    _clearMarkers();
    selectedTour = tour;

    for (int i = 0; i < tour.keyPoints.length; i++) {
      final KeyPoint keyPoint = tour.keyPoints[i];
      markers[keyPoint.name] = Marker(
        markerId: MarkerId(keyPoint.name),
        icon: i == 0
            ? await getLocationIcon("blue")
            : i == tour.keyPoints.length - 1
                ? await getLocationIcon("blue")
                : await getLocationIcon("blue"),
        position: keyPoint.getLocation(),
      );

      if (i != tour.keyPoints.length - 1) {
        createPolyline(
          keyPoint.getLocation(),
          tour.keyPoints[i + 1].getLocation(),
          "${keyPoint.name}/${tour.keyPoints[i + 1].name}",
          secondaryColor,
        );
      }
    }

    setState(() {});
  }

  void _startTour() {
    if (selectedTour == null) throw Exception("Tour not selected");
    selectedTour!.startTour();
    isTourActive = true;
    LatLng nextKeyPointLocation = selectedTour!.getNextKeyPointLocation();
    createPolyline(currentLoc!, nextKeyPointLocation, "user", primaryColor);
    _keypointCheck();
    _mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
            currentLoc!, 15), // Adjust zoom level as needed
      );
    });
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
          name: "Kuca",
          description:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
          images: [
            "https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg",
            "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_640.jpg",
            "image2.jpg"
          ],
          latitude: 45.262996,
          longitude: 19.822959),
      KeyPoint(
          id: 2,
          name: "Sima",
          description: "Description of Sima",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image2.jpg"
          ],
          latitude: 45.262501,
          longitude: 19.839263),
      KeyPoint(
          id: 3,
          name: "Vruce kifle",
          description: "Description of Vruce kifle",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.255452,
          longitude: 19.841251),
    ];
    List<KeyPoint> keyPoints2 = [
      KeyPoint(
          id: 4,
          name: "Univer",
          description: "Description of Univer",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image2.jpg"
          ],
          latitude: 45.253334,
          longitude: 19.844478),
      KeyPoint(
          id: 5,
          name: "Burgija",
          description: "Description of Burgija",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.239358,
          longitude: 19.850856),
    ];
    List<KeyPoint> keyPoints3 = [
      KeyPoint(
          id: 6,
          name: "NTP",
          description: "Description of NTP",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image2.jpg"
          ],
          latitude: 45.244923,
          longitude: 19.847757),
      KeyPoint(
          id: 7,
          name: "Turbo kruzni",
          description: "Description of Turbo",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.244777,
          longitude: 19.84679),
      KeyPoint(
          id: 8,
          name: "Tocionica",
          description: "Description of Turbo kruzni",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.24262,
          longitude: 19.846887),
      KeyPoint(
          id: 9,
          name: "Iza ugla",
          description: "Description of Tocionica",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.242733,
          longitude: 19.849508),
      KeyPoint(
          id: 10,
          name: "NTP opet",
          description: "Description of NTP opet",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image4.jpg"
          ],
          latitude: 45.244368,
          longitude: 19.848467),
    ];

    List<KeyPoint> keyPoints4 = [
      KeyPoint(
          id: 11,
          name: "Sumnjivo dvoriste",
          description: "Setam samo sa osobama zenskog pola",
          images: [
            "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
            "image2.jpg"
          ],
          latitude: 45.244085,
          longitude: 19.852904),
    ];

    Tour newTour = Tour(
        name: "Put do kifli",
        description: "Najbrzi put do vrucih(mozda) kifli",
        keyPoints: keyPoints);
    Tour newTour2 = Tour(
        name: "Poseta burice",
        description: "Do mog dragog brata",
        keyPoints: keyPoints2);
    Tour newTour3 = Tour(
        name: "Setnja sa Luburom",
        description: "Sa nasim dragim profesorom",
        keyPoints: keyPoints3);
    Tour newTour4 = Tour(
        name: "Sumnjivo dvoriste na limanu",
        description: "Easter egg tura",
        keyPoints: keyPoints4);
    tours.add(newTour);
    tours.add(newTour2);
    tours.add(newTour3);
    tours.add(newTour4);
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

    _locationController.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          final newLoc =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _setUserMarker(newLoc);
          if (currentLoc != newLoc) {
            setState(
              () {
                currentLoc = newLoc;
                if (isTourActive && selectedTour != null) {
                  _keypointCheck();

                  if (selectedTour!.isCompleted) {
                    _completeTour();
                    return;
                  }

                  createPolyline(
                      currentLoc!,
                      selectedTour!.getNextKeyPointLocation(),
                      "user",
                      primaryColor);
                }
              },
            );
          }
        }
      },
    );
  }

  void _setUserMarker(LatLng loc) {
    markers["_currentLocation"] = Marker(
        markerId: const MarkerId("_currentLocation"),
        icon: userIcon,
        position: loc,
        zIndex: 100);
  }

  void _showAbandonModal() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: foregroundColor,
        contentTextStyle: const TextStyle(color: textLightColor, fontSize: 16),
        title: const Text(
          'Abandon Tour',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
        ),
        content: const Text('Are you sure you want to abandon the tour?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'No',
              style: TextStyle(
                  decorationColor: borderColor,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                  fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              _abandonTour();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _abandonTour() {
    selectedTour!.abandonTour();
    isTourActive = false;
    selectedTour = null;
    valueNotifier.value = 0;
    _resetMap();
  }

  void _completeTour() {
    debugPrint("COMPLETED");
    showSnackBar(context, "Completed tour ${selectedTour!.name}");
    isTourActive = false;
    selectedTour = null;
    valueNotifier.value = 0;
    _resetMap();
  }

  void _completeKeyPoint() {
    if (selectedTour!.nextKeyPoint + 1 < selectedTour!.keyPoints.length) {
      debugPrint("OPET PIZDARIJA SE DESILA");
      deleteRoute(
          "${selectedTour!.keyPoints[selectedTour!.nextKeyPoint].name}/${selectedTour!.keyPoints[selectedTour!.nextKeyPoint + 1].name}");
    }
    deleteKeyPoint(selectedTour!.keyPoints[selectedTour!.nextKeyPoint].name);
    selectedTour!.completeKeyPoint();
  }

  void _keypointCheck() {
    if (calculateDistance()) {
      _changeNextKeypointPin(
          selectedTour!.keyPoints[selectedTour!.nextKeyPoint]);
      // _vibrate();
      // showSnackBar(context,
      //     "Completed key point ${selectedTour!.keyPoints[selectedTour!.nextKeyPoint].name}");
      // valueNotifier.value =
      //     selectedTour!.nextKeyPoint * 100 / selectedTour!.keyPoints.length;
    }
  }

  void _showKeyPoint(KeyPoint keyPoint) {
    showDialog(
        context: context,
        builder: (_) => KeyPointModal(
              keyPoint: keyPoint,
              onComplete: _completeKeyPoint,
            ));
  }

  void _vibrate() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
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

  void createPolylineLocal(LatLng source, LatLng dest, String polylineId,
      Color polyLineColor) async {
    final response = await http.post(
      Uri.parse("http://192.168.1.9:8086/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{"pos": source, "dest": dest},
      ),
    );

    if (response.statusCode != 200) throw Exception("Failed to create route");
    final list = jsonDecode(response.body) as List;
    debugPrint(list.toString());
    final points = list.map((e) => e.cast<double>()).toList();

    List<LatLng> polylineCoords = [];
    for (var point in points) {
      polylineCoords.add(LatLng(point[0], point[1]));
    }
    setState(() {
      currentPolylines[polylineId] = Polyline(
          polylineId: PolylineId(polylineId),
          points: polylineCoords,
          width: 6,
          color: polyLineColor);
    });
  }

  Future<BitmapDescriptor> getLocationIcon(String color) async {
    ByteData byteData;
    if (color == "orange") {
      byteData =
          await DefaultAssetBundle.of(context).load("assets/orange_marker.png");
    } else if (color == "blue") {
      byteData =
          await DefaultAssetBundle.of(context).load("assets/blue_marker.png");
    } else {
      byteData =
          await DefaultAssetBundle.of(context).load("assets/green_marker.png");
    }
    ui.Codec codec = await ui
        .instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 150);
    ui.FrameInfo fi = await codec.getNextFrame();
    final icon = BitmapDescriptor.fromBytes(
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List());

    return icon;
  }

  void getUserIcon() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/user_marker.png");
    ui.Codec codec = await ui
        .instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 150);
    ui.FrameInfo fi = await codec.getNextFrame();
    final icon = BitmapDescriptor.fromBytes(
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List());
    setState(() {
      userIcon = icon;
    });
  }

  bool calculateDistance() {
    var p = 0.017453292519943295;
    var c = cos;
    if (selectedTour == null) throw Exception("Tour not selected");
    LatLng nextKeyPointLocation = selectedTour!.getNextKeyPointLocation();
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

  void deleteKeyPoint(String currentKeyPoint) {
    markers.remove(currentKeyPoint);
  }

  void deleteRoute(String route) {
    currentPolylines.remove(route);
  }

  _changeNextKeypointPin(KeyPoint keyPoint) async {
    markers[keyPoint.name] = Marker(
      markerId: MarkerId(keyPoint.name),
      icon: await getLocationIcon("green"),
      position: keyPoint.getLocation(),
      onTap: () {
        _showKeyPoint(keyPoint);
      },
    );
  }
}
