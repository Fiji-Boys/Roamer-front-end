// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/key_point_info.dart';
import 'package:figenie/pages/osmap/osmap_controller.dart';
import 'package:figenie/widgets/tour_info.dart';
import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/widgets/tour_progress.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class OSMapView extends StatefulWidget {
  final OSMapController state;

  const OSMapView(this.state, {super.key});

  @override
  _OSMapViewState createState() => _OSMapViewState();
}

class _OSMapViewState extends State<OSMapView> {
  final ValueNotifier<int> _nextKeyPointIndexNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _updateNextKeyPointIndex(widget.state.selectedTour?.nextKeyPoint ?? 0);
  }

  @override
  void didUpdateWidget(covariant OSMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.selectedTour != oldWidget.state.selectedTour) {
      _updateNextKeyPointIndex(widget.state.selectedTour?.nextKeyPoint ?? 0);
    }
  }

  void _updateNextKeyPointIndex(int nextKeyPointIndex) {
    _nextKeyPointIndexNotifier.value = nextKeyPointIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.state.isTourActive) {
          widget.state.showAbandonModal();
        } else {
          widget.state.resetMap();
        }
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: widget.state.mapController.mapController,
              options: const MapOptions(
                initialZoom: 16,
                initialCenter: LatLng(45.262501, 19.839263),
                interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                PolylineLayer(
                  polylines: widget.state.currentPolylines.values.toList(),
                ),
                MarkerLayer(markers: [
                  Marker(
                      point: widget.state.currentLoc,
                      width: 40,
                      height: 40,
                      child: widget.state.userIcon)
                ]),
                AnimatedMarkerLayer(
                  markers: widget.state.markers.values.toList(),
                ),
              ],
            ),
            widget.state.isTourActive == true &&
                    widget.state.selectedTour != null &&
                    widget.state.selectedTour?.type != TourType.secret
                ? Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.topCenter,
                      child: TourProgressWidget(
                        tour: widget.state.selectedTour!,
                        nextKeyPointIndex:
                            widget.state.selectedTour!.nextKeyPoint,
                        currentLocation: widget.state.currentLoc,
                      ),
                    ),
                  )
                : Container(),
            widget.state.selectedTour == null
                ? Container()
                : TourInfo(
                    nextKeyPointIndex: widget.state.selectedTour!.nextKeyPoint,
                    onStartTour: widget.state.startTour,
                    tour: widget.state.selectedTour!,
                    valueNotifier: widget.state.valueNotifier,
                    isTourActive: widget.state.isTourActive,
                  ),
            widget.state.isTourActive == false &&
                    widget.state.selectedTour != null
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        backgroundColor: foregroundColor,
                        foregroundColor: textColor,
                        onPressed: () {
                          if (widget.state.isTourActive) {
                            widget.state.showAbandonModal();
                          } else {
                            widget.state.resetMap();
                          }
                        },
                        child: const Icon(Icons.close),
                      ),
                    ),
                  )
                : Container(),
            widget.state.selectedKeypoint == null
                ? Container()
                : Center(
                    child: KeyPointInfo(
                        keyPoint: widget.state.selectedKeypoint!,
                        onComplete: widget.state.completeKeyPoint,
                        onBack: widget.state.goBack),
                  )
          ],
        ),
      ),
    );
  }
}
