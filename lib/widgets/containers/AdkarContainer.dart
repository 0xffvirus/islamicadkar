import 'package:flutter/material.dart';

Container AdkarContainer(
    double height, double width, String text, String path) {
  return Container(
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "$text",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "Inter",
                fontWeight: FontWeight.normal),
          ),
        ),
        Image.asset(
          "$path",
          scale: 7.5,
          fit: BoxFit.cover,
        )
      ],
    ),
    height: height * 0.08,
    width: width * 0.41,
    decoration: BoxDecoration(
        color: Color(0xff424242), borderRadius: BorderRadius.circular(18)),
  );
}
