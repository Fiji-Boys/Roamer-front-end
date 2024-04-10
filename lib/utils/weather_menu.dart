// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:figenie/consts.dart';

class WeatherMenu extends StatefulWidget {
  final LatLng currentLoc;

  const WeatherMenu({super.key, required this.currentLoc});

  @override
  State<WeatherMenu> createState() => _WeatherMenu();
}

class _WeatherMenu extends State<WeatherMenu> {
  Weather? _weather;
  late String? _city;

  @override
  void initState() {
    super.initState();
    fetchWeather(widget.currentLoc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryContentColor,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Expanded(
          child: Center(
        child: CircularProgressIndicator(
          color: secondaryColor, // replace with your desired color
        ),
      ));
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_locationHeadher()],
      ),
    );
  }

  Widget _locationHeadher() {
    return const Text("_city!");
  }

  void fetchWeather(LatLng currentLoc) async {
    final city = await fetchCity(currentLoc);

    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/weather?city=$city'),
      headers: {"X-API-Key": weatherApiKey},
    );

    if (response.statusCode == 200) {
      var weatherData = jsonDecode(response.body);

      // Replace 'temp', 'minTemp', 'maxTemp', 'windSpeed' with the actual keys in the response.
      // Access the relevant fields in the weatherData Map.
      double temperature = weatherData['temp'].toDouble();
      double minTemp = weatherData['min_temp'].toDouble();
      double maxTemp = weatherData['max_temp'].toDouble();
      double windSpeed = weatherData['wind_speed'].toDouble();

      _weather = Weather(
        temperature: temperature,
        minTemp: minTemp,
        maxTemp: maxTemp,
        windSpeed: windSpeed,
      );
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> fetchCity(LatLng currentLoc) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLoc.latitude, currentLoc.longitude);
    return placemarks[0].locality!;
  }
}

class Weather {
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final double windSpeed;

  Weather({
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.windSpeed,
  });
}
