import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamicadkar/providers/location.dart';

class QuranReading extends StatefulWidget {
  late int index;

  QuranReading({super.key, required this.index});

  @override
  State<QuranReading> createState() => _QuranReadingState();
}

class _QuranReadingState extends State<QuranReading> {
  @override
  Widget build(BuildContext context) {
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
                      " ${context.watch<Counter>().qurandata[widget.index]["array"].length} آية",
                      style: const TextStyle(
                        color: Color(0xff696969),
                        fontSize: 15,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(
                      "سورة ${context.watch<Counter>().qurandata[widget.index]["name"]}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SelectableText(
                  "${context.watch<Counter>().qurandata[widget.index]["ar"]}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    height: 3,
                    wordSpacing: 5,
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: "quran",
                  ),
                  textDirection: TextDirection.rtl,
                ),
              )
            ],
          )),
        ));
  }
}
