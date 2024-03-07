import 'package:flutter/material.dart';

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
            "الصفحة تحت التطوير\nبرمجة : بهاء\nTwitter: @0xkfupm",
            style: TextStyle(
                color: Color(0xffa9a9a9), fontFamily: "Inter", fontSize: 18),
            textDirection: TextDirection.rtl,
          ))
        ],
      ),
    );
  }
}
