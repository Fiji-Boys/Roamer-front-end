import 'package:figenie/pages/key_point_info.dart';
import 'package:figenie/widgets/tour_info.dart';
import 'package:figenie/widgets/tour_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

import 'package:figenie/consts.dart';
import 'package:figenie/pages/osmap/osmap_controller.dart';
import 'package:latlong2/latlong.dart';

class OSMapView extends StatelessWidget {
  final OSMapController state;
  const OSMapView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (state.isTourActive) {
          state.showAbandonModal();
        } else {
          state.resetMap();
        }
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: state.mapController.mapController,
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
                  polylines: state.currentPolylines.values.toList(),
                ),
                MarkerLayer(markers: [
                  Marker(
                      point: state.currentLoc,
                      width: 40,
                      height: 40,
                      child: state.userIcon)
                ]),
                AnimatedMarkerLayer(
                  markers: state.markers.values.toList(),
                ),
              ],
            ),
            state.isTourActive == true && state.selectedTour != null
                ? Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.topCenter,
                      child: TourProgressWidget(tour: state.selectedTour!),
                    ),
                  )
                : Container(),
            state.selectedTour == null
                ? Container()
                : TourInfo(
                    onStartTour: state.startTour,
                    tour: state.selectedTour!,
                    valueNotifier: state.valueNotifier,
                    isTourActive: state.isTourActive,
                  ),
            state.isTourActive == false && state.selectedTour != null
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        backgroundColor: foregroundColor,
                        foregroundColor: textColor,
                        onPressed: () {
                          if (state.isTourActive) {
                            state.showAbandonModal();
                          } else {
                            state.resetMap();
                          }
                        },
                        child: const Icon(Icons.close),
                      ),
                    ),
                  )
                : Container(),
            state.selectedKeypoint == null
                ? Container()
                : Center(
                    child: KeyPointInfo(
                        keyPoint: state.selectedKeypoint!,
                        onComplete: state.completeKeyPoint,
                        onBack: state.goBack),
                  )
          ],
        ),
      ),
    );
  }
}
