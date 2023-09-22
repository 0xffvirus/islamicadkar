import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamicadkar/providers/location.dart';

class MorningScreen extends StatefulWidget {
  const MorningScreen({super.key});

  @override
  State<MorningScreen> createState() => _MorningScreenState();
}

class _MorningScreenState extends State<MorningScreen> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xff121212),
        ),
        backgroundColor: Color(0xff121212),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "${count + 1}/15",
                      style: TextStyle(
                          color: Color(0xff696969),
                          fontSize: 15,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(
                      "اذكار الصباح",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 240,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${context.watch<Counter>().adkardata["morning"][count]["content"]}",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        if (count >= 0 && count < 14) {
                          setState(() {
                            count++;
                          });
                        }
                      },
                      child: NeContainer(height, width, "التالي")),
                  GestureDetector(
                      onTap: () {
                        if (count > 0 && count <= 14) {
                          setState(() {
                            count--;
                          });
                        }
                      },
                      child: NeContainer(height, width, "الرجوع"))
                ],
              )
            ],
          )),
        ));
  }
}

Container NeContainer(double height, double width, String text) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "$text",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "Inter",
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
    ),
    height: height * 0.08,
    width: width * 0.41,
    decoration: BoxDecoration(
        color: Color(0xff424242), borderRadius: BorderRadius.circular(18)),
  );
}
