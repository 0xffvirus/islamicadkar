import 'package:flutter/material.dart';
import 'package:islamicadkar/screens/afternoonScreen.dart';
import 'package:islamicadkar/screens/mainadkarScreen.dart';
import 'package:islamicadkar/screens/morningScreen.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';
import 'providers/location.dart';
import 'screens/PrayerScreen.dart';
import 'screens/qiblaScreen.dart';
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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController pageController;
  int selectedIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    context.read<Counter>().requestlocation();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[MainAdkarScreen(), PrayersTime(), QiblaCompass()],
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
