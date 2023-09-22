import 'package:flutter/material.dart';
import 'package:islamicadkar/providers/location.dart';
import 'package:provider/provider.dart';

Padding PrayerContainer(BuildContext context, double height, double width,
    var prayerprovider, String prayer, String image, String prayernext) {
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
          color: context.watch<Counter>().nextprayer == "$prayernext"
              ? Color(0xff696969)
              : Color(0xff434343),
          borderRadius: BorderRadius.circular(12)),
    ),
  );
}
