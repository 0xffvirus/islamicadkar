import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class Counter with ChangeNotifier {
  //Variables
  Position? _userLocation;
  dynamic fajr;
  dynamic dohr;
  dynamic asr;
  dynamic magrib;
  dynamic isha;
  dynamic _adkardata;
  dynamic _qurandata;
  String userCity = 'Loading...';
  int _countsuhba = 0;

  String _nextprayer = "null";
  // Providers
  Position? get userloc => _userLocation;
  dynamic get fajrprayer => fajr;
  dynamic get dohrprayer => dohr;
  dynamic get asrprayer => asr;
  dynamic get magribprayer => magrib;
  dynamic get ishaprayer => isha;
  dynamic get adkardata => _adkardata;
  dynamic get qurandata => _qurandata;
  String get userWhereCity => userCity;
  String get nextprayer => _nextprayer;
  int get countsubha => _countsuhba;

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

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/athkar.json');
    final data = await json.decode(response);
    _adkardata = data;
    notifyListeners();
  }

  Future<void> readJsonQuran() async {
    final String response = await rootBundle.loadString('assets/quran.json');
    final data = await json.decode(response);
    _qurandata = data;
    notifyListeners();
  }

  void AddCount() {
    _countsuhba++;
    notifyListeners();
  }

  void ResetCount() {
    _countsuhba = 0;
    notifyListeners();
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
      var fajrraw = jsonData["data"]["timings"]["Fajr"].toString();
      var dohrraw = jsonData["data"]["timings"]["Dhuhr"].toString();
      var asrraw = jsonData["data"]["timings"]["Asr"].toString();
      var magribraw = jsonData["data"]["timings"]["Maghrib"].toString();
      var isharaw = jsonData["data"]["timings"]["Isha"].toString();
      var time = TimeOfDay.now();
      double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
      fajr = convertTo12HourFormat(fajrraw);
      dohr = convertTo12HourFormat(dohrraw);
      asr = convertTo12HourFormat(asrraw);
      magrib = convertTo12HourFormat(magribraw);
      isha = convertTo12HourFormat(isharaw);
      if (toDouble(time) <
          toDouble(TimeOfDay(
              hour: int.parse(fajrraw.substring(0, 2)),
              minute: int.parse(fajrraw.substring(3, 5))))) {
        _nextprayer = "Fajr";
      } else if (toDouble(time) <
              toDouble(TimeOfDay(
                  hour: int.parse(dohrraw.substring(0, 2)),
                  minute: int.parse(dohrraw.substring(3, 5)))) &&
          toDouble(time) >
              toDouble(TimeOfDay(
                  hour: int.parse(fajrraw.substring(0, 2)),
                  minute: int.parse(fajrraw.substring(3, 5))))) {
        _nextprayer = "Dohr";
      } else if (toDouble(time) < toDouble(TimeOfDay(hour: int.parse(asrraw.substring(0, 2)), minute: int.parse(asrraw.substring(3, 5)))) &&
          toDouble(time) >
              toDouble(TimeOfDay(
                  hour: int.parse(dohrraw.substring(0, 2)),
                  minute: int.parse(dohrraw.substring(3, 5))))) {
        _nextprayer = "Asr";
      } else if (toDouble(time) <
              toDouble(TimeOfDay(
                  hour: int.parse(magribraw.substring(0, 2)),
                  minute: int.parse(magribraw.substring(3, 5)))) &&
          toDouble(time) >
              toDouble(TimeOfDay(
                  hour: int.parse(asrraw.substring(0, 2)),
                  minute: int.parse(asrraw.substring(3, 5))))) {
        _nextprayer = "Magrib";
      } else if (toDouble(time) <
              toDouble(TimeOfDay(
                  hour: int.parse(isharaw.substring(0, 2)),
                  minute: int.parse(isharaw.substring(3, 5)))) &&
          toDouble(time) >
              toDouble(TimeOfDay(
                  hour: int.parse(magribraw.substring(0, 2)),
                  minute: int.parse(magribraw.substring(3, 5))))) {
        _nextprayer = "Isha";
      } else if (toDouble(time) >
          toDouble(
              TimeOfDay(hour: int.parse(isharaw.substring(0, 2)), minute: int.parse(isharaw.substring(3, 5))))) {
        _nextprayer = "Fajr";
      } else {
        _nextprayer = "null";
        print(toDouble(time));
        print(toDouble(TimeOfDay(
            hour: int.parse(isharaw.substring(0, 2)),
            minute: int.parse(isharaw.substring(3, 5)))));
      }
      print(nextprayer);
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
