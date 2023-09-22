import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';
import 'providers/location.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Counter()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      routes: {
        "/main": (context) => PrayersTime(),
        "/qibla": (context) => QiblaCompass(),
        "/": (context) => MainScreen()
      },
      initialRoute: "/",
    );
  }
}

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
  Future<String> getUserCity() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Adjust accuracy as needed
      );

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks[0];
        final String city = placemark.locality ?? 'Unknown City';
        return city;
      } else {
        return 'Unknown City';
      }
    } catch (e) {
      print("Error getting user's city: $e");
      return 'Unknown City';
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

  Future<void> PrayerData(Position? userloc) async {
    final url = Uri.parse(
        'https://api.aladhan.com/v1/timings/02-09-2023?latitude=${context.watch<Counter>().userloc?.latitude}&longitude=${context.watch<Counter>().userloc?.longitude}'); // Replace with your desired URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      final jsonData = json.decode(response.body);
      setState(() {
        fajr = convertTo12HourFormat(jsonData["data"]["timings"]["Fajr"]);
        dohr = convertTo12HourFormat(jsonData["data"]["timings"]["Dhuhr"]);
        asr = convertTo12HourFormat(jsonData["data"]["timings"]["Asr"]);
        magrib = convertTo12HourFormat(jsonData["data"]["timings"]["Maghrib"]);
        isha = convertTo12HourFormat(jsonData["data"]["timings"]["Isha"]);
      });
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
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
                      "assets/icons/sunrise.png"),
                  PrayerContainer(
                      context,
                      height,
                      width,
                      context.watch<Counter>().dohrprayer,
                      "الظهر",
                      "assets/icons/sunrisedohr.png"),
                  PrayerContainer(
                      context,
                      height,
                      width,
                      context.watch<Counter>().asrprayer,
                      "العصر",
                      "assets/icons/sunriseasr.png"),
                  PrayerContainer(
                      context,
                      height,
                      width,
                      context.watch<Counter>().magribprayer,
                      "المغرب",
                      "assets/icons/sundownmagrib.png"),
                  PrayerContainer(
                      context,
                      height,
                      width,
                      context.watch<Counter>().ishaprayer,
                      "العشاء",
                      "assets/icons/sundownisha.png"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "اذكار المساء",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Image.asset(
                          "assets/icons/sundownisha.png",
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                    height: height * 0.08,
                    width: width * 0.41,
                    decoration: BoxDecoration(
                        color: Color(0xff424242),
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "اذكار الصباح",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Image.asset(
                          "assets/icons/sunrise.png",
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                    height: height * 0.08,
                    width: width * 0.41,
                    decoration: BoxDecoration(
                        color: Color(0xff424242),
                        borderRadius: BorderRadius.circular(18)),
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

  Padding PrayerContainer(BuildContext context, double height, double width,
      var prayerprovider, String prayer, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "${prayerprovider == null ? "loading" : prayerprovider}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Inter",
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "$prayer",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.normal),
                ),
                Image.asset(
                  "$image",
                  fit: BoxFit.cover,
                ),
              ],
            )
          ]),
        ),
        height: height * 0.08,
        width: width * 0.9,
        decoration: BoxDecoration(
            color: Color(0xff424242), borderRadius: BorderRadius.circular(8)),
      ),
    );
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

class QiblaCompass extends StatefulWidget {
  @override
  _QiblaCompassState createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "under maintain",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    context.read<Counter>().requestlocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[
          Scaffold(
            backgroundColor: Color(0xff121212),
            body: Center(
              child: Text(
                "${context.watch<Counter>().userloc}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          PrayersTime(),
          QiblaCompass()
        ],
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: Color(0xff434343),
        waterDropColor: Colors.white,
        barItems: [
          BarItem(
              filledIcon: FlutterIslamicIcons.solidTasbih2,
              outlinedIcon: FlutterIslamicIcons.tasbih2),
          BarItem(
              filledIcon: FluentIcons.building_mosque_16_filled,
              outlinedIcon: FluentIcons.building_mosque_16_regular),
          BarItem(
              filledIcon: FluentIcons.compass_northwest_16_filled,
              outlinedIcon: FluentIcons.compass_northwest_16_regular),
        ],
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
          pageController.animateToPage(selectedIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad);
        },
      ),
    );
  }
}
