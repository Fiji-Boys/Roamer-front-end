// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
// import 'package:geocoding/geocoding.dart';

import 'package:figenie/consts.dart';
import 'package:weather/weather.dart';

class WeatherInfo extends StatefulWidget {
  final LatLng currentLoc;

  const WeatherInfo({super.key, required this.currentLoc});

  @override
  State<WeatherInfo> createState() => _WeatherInfo();
}

class _WeatherInfo extends State<WeatherInfo> {
  final WeatherFactory _weatherFactory = WeatherFactory(weatherApiKey);

  Weather? _weather;
  // late String _city;

  @override
  void initState() {
    super.initState();
    // fetchCity(widget.currentLoc).then((city) => setState(() {
    //       _city = city;
    //     }));
    _weatherFactory
        .currentWeatherByCityName("Novi Sad")
        .then((weather) => setState(() {
              _weather = weather;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width, child: _buildUI());
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: secondaryColor,
        ),
      );
    }

    // Container takes up the full width of the screen
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      color: primaryContentColor.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment
            .end, // Align the column to the end of the container
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Align the row content to the end
            children: [
              const Icon(
                Icons.location_on,
                color: textColor,
                size: 12,
              ),
              const SizedBox(width: 5),
              _locationHeader(),
            ],
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Align the row content to the end
            children: [_weatherIcon(), _currentTemp()],
          ),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        color: textColor,
        fontSize: 12,
      ),
    );
  }

  Widget _weatherIcon() {
    // Ensure that _weather is not null and has a valid weatherIcon value
    final iconUrl = _weather?.weatherIcon != null
        ? "http://openweathermap.org/img/wn/${_weather!.weatherIcon}@4x.png"
        : null;

    // If there is no valid icon URL, we don't want to display the container
    if (iconUrl == null) {
      return SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height *
              0.04, // Corrected MediaQuery method
          width: MediaQuery.of(context).size.height *
              0.04, // Provide a width to maintain aspect ratio
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit
                  .fill, // Use BoxFit.fill to make sure the image fills the container
              image: NetworkImage(iconUrl),
            ),
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// Future<String> fetchCity(LatLng currentLoc) async {
//   List<Placemark> placemarks = await placemarkFromCoordinates(
//       currentLoc.latitude, currentLoc.longitude);
//   return placemarks[0].locality!;
// }
