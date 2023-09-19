import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Counter with ChangeNotifier {
  //Variables
  Position? _userLocation;
  dynamic fajr;
  dynamic dohr;
  dynamic asr;
  dynamic magrib;
  dynamic isha;
  String userCity = 'Loading...';

  // Providers
  Position? get userloc => _userLocation;
  dynamic get fajrprayer => fajr;
  dynamic get dohrprayer => dohr;
  dynamic get asrprayer => asr;
  dynamic get magribprayer => magrib;
  dynamic get ishaprayer => isha;
  String get userWhereCity => userCity;

  void RequestSensors() async {
    final status = await Permission.sensors.request();
    if (status.isGranted) {
      print("Sensors Done");
    } else if (status.isDenied) {
      print("access denied");
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, open app settings so the user can enable it
      openAppSettings();
    }
  }

  String getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    return formatted;
  }

  void requestlocation() async {
    // Request location permission
    final status = await Permission.location.request();

    // Check if permission is granted
    if (status.isGranted) {
      getUserLocation().then((position) {
        if (position != null) {
          _userLocation = position;
          PrayerData(_userLocation, getDate());
          getUserCity();
          notifyListeners();
        }
      });
    } else if (status.isDenied) {
      print("access denied");
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, open app settings so the user can enable it
      openAppSettings();
    }
  }

  Future<void> PrayerData(Position? userloc, String Date) async {
    final url = Uri.parse(
        'https://api.aladhan.com/v1/timings/${Date}?latitude=${_userLocation?.latitude}&longitude=${_userLocation?.longitude}'); // Replace with your desired URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      final jsonData = json.decode(response.body);
      fajr = convertTo12HourFormat(jsonData["data"]["timings"]["Fajr"]);
      dohr = convertTo12HourFormat(jsonData["data"]["timings"]["Dhuhr"]);
      asr = convertTo12HourFormat(jsonData["data"]["timings"]["Asr"]);
      magrib = convertTo12HourFormat(jsonData["data"]["timings"]["Maghrib"]);
      isha = convertTo12HourFormat(jsonData["data"]["timings"]["Isha"]);
      notifyListeners();
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  Future<Position?> getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Adjust accuracy as needed
      );
      return position;
    } catch (e) {
      print("Error getting user location: $e");
      return null;
    }
  }

  String convertTo12HourFormat(String time24Hour) {
    try {
      final hourMinute = time24Hour.split(':');
      var hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);

      String period = 'am';

      if (hour >= 12) {
        period = 'pm';
        if (hour > 12) {
          hour -= 12;
        }
      }

      final formattedHour = hour.toString().padLeft(2, '0');
      final formattedMinute = minute.toString().padLeft(2, '0');

      return '$formattedHour:$formattedMinute $period';
    } catch (e) {
      return 'Invalid Time';
    }
  }

  Future getUserCity() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Adjust accuracy as needed
      );
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks[0];
        final String city = placemark.locality ?? 'Unknown City';
        userCity = city;
        notifyListeners();
      } else {
        userCity = "Unknowen City";
        notifyListeners();
      }
    } catch (e) {
      print("Error getting user's city: $e");
      userCity = "Unknowen City";
      notifyListeners();
    }
  }
}
