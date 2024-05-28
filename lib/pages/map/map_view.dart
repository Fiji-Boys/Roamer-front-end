import 'package:figenie/consts.dart';
import 'package:figenie/pages/map/map_controller.dart';
import 'package:figenie/widgets/loading.dart';
import 'package:figenie/widgets/tour_info.dart';
// import 'package:figenie/widgets/weather_info.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  final MapController state;
  const MapView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        state.resetMap();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            state.currentLoc == null
                ? const Center(
                    child: Loading(),
                  )
                : GoogleMap(
                    onMapCreated: ((GoogleMapController controller) =>
                        state.mapController.complete(controller)),
                    initialCameraPosition: CameraPosition(
                      target: state.startLoc,
                      zoom: 13,
                    ),
                    markers: Set<Marker>.of(state.markers.values),
                    polylines: Set<Polyline>.of(state.currentPolylines.values),
                    compassEnabled: false,
                    zoomControlsEnabled: false,
                  ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 7.0),
            //   child: Align(
            //     alignment: Alignment.topLeft,
            //     child: state.currentLoc != null
            //         ? WeatherInfo(currentLoc: state.currentLoc!)
            //         : Container(
            //             color: foregroundColor,
            //             height: 50.0,
            //           ),
            //   ),
            // ),
            state.selectedTour == null
                ? Container()
                : TourInfo(
                    tour: state.selectedTour!,
                    onStartTour: state.startTour,
                    valueNotifier: state.valueNotifier,
                    isTourActive: state.isTourActive,
                  ),
            state.selectedTour != null
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
                          if (state.isTourActive) {
                            state.showAbandonModal();
                          } else {
                            state.resetMap();
                          }
                        },
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
