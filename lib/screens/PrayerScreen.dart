import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamicadkar/screens/afternoonScreen.dart';
import 'package:islamicadkar/screens/morningScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/location.dart';
import 'package:islamicadkar/widgets/containers/PrayerContainer.dart';
import 'package:islamicadkar/widgets/containers/AdkarContainer.dart';

class PrayersTime extends StatefulWidget {
  const PrayersTime({super.key});

  @override
  State<PrayersTime> createState() => _PrayersTimeState();
}

class _PrayersTimeState extends State<PrayersTime> {
  Position? userLocation;

  dynamic fajr;
  dynamic dohr;
  dynamic asr;
  dynamic magrib;
  dynamic isha;
  String userCity = 'Loading...';
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

  void requestLocationPermission() async {
    // Request location permission
    final status = await Permission.location.request();

    // Check if permission is granted
    if (status.isGranted) {
      getUserLocation().then((position) {
        if (position != null) {
          setState(() {
            userLocation = position;
            if (userLocation != null) {}
            print(position);
          });

          print(userLocation);
        }
      });
    } else if (status.isDenied) {
      print("access denied");
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, open app settings so the user can enable it
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    var time = TimeOfDay.now();
    double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
    print(toDouble(time));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      "تواقيت الصلاة",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrayerContainer(
                      context,
                      height,
                      width,
                      context.watch<Counter>().fajrprayer,
                      "الفجر",
                      "assets/icons/sunrise.png",
                      "Fajr"),
                  PrayerContainer(
                      context,
                      height,
                      width,
                      context.watch<Counter>().dohrprayer,
                      "الظهر",
                      "assets/icons/sunrisedohr.png",
                      "Dohr"),
                  PrayerContainer(
                      context,
                      height,
                      width,
                      context.watch<Counter>().asrprayer,
                      "العصر",
                      "assets/icons/sunriseasr.png",
                      "Asr"),
                  PrayerContainer(
                      context,
                      height,
                      width,
                      context.watch<Counter>().magribprayer,
                      "المغرب",
                      "assets/icons/sundownmagrib.png",
                      "Magrib"),
                  PrayerContainer(
                      context,
                      height,
                      width,
                      context.watch<Counter>().ishaprayer,
                      "العشاء",
                      "assets/icons/sundownisha.png",
                      "Isha"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<Counter>().readJson();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AfternoonScreen()));
                    },
                    child: AdkarContainer(height, width, "اذكار المساء",
                        "assets/icons/sundownisha.png"),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<Counter>().readJson();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MorningScreen()));
                    },
                    child: AdkarContainer(height, width, "اذكار الصباح",
                        "assets/icons/sunrise.png"),
                  )
                ],
              ),
            ),
            Center(
              child: Text(
                "المدينة: ${context.watch<Counter>().userCity}",
                style: TextStyle(
                    color: Color(0xffa9a9a9),
                    fontFamily: "Inter",
                    fontSize: 18),
              ),
            )
          ],
        ),
      )),
    );
  }
}
