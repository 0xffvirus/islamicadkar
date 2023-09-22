import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamicadkar/providers/location.dart';
import 'morningScreen.dart';
import 'afternoonScreen.dart';

class MainAdkarScreen extends StatefulWidget {
  const MainAdkarScreen({super.key});

  @override
  State<MainAdkarScreen> createState() => _MainAdkarScreenState();
}

class _MainAdkarScreenState extends State<MainAdkarScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        backgroundColor: Color(0xff121212),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
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
              ),
              GestureDetector(
                onTap: () {
                  context.read<Counter>().readJson();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MorningScreen()));
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "اللّهـمَّ أَنْتَ رَبِّـي لا إلهَ إلاّ أَنْتَ ، خَلَقْتَنـي وَأَنا عَبْـدُك ، وَأَنا عَلـى عَهْـدِكَ وَوَعْـدِكَ ما اسْتَـطَعْـت ، أَعـوذُبِكَ مِنْ شَـرِّ ما صَنَـعْت ، أَبـوءُ لَـكَ بِنِعْـمَتِـكَ عَلَـيَّ وَأَبـوءُ بِذَنْـبي فَاغْفـِرْ لي فَإِنَّـهُ لا يَغْـفِرُ الذُّنـوبَ إِلاّ أَنْتَ",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  height: height * 0.2,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      color: Color(0xff434343),
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Text(
                        "اذكار المساء",
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
              GestureDetector(
                onTap: () {
                  context.read<Counter>().readJson();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AfternoonScreen()));
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "اللّهُـمَّ إِنِّـي أَمسيتُ أُشْـهِدُك ، وَأُشْـهِدُ حَمَلَـةَ عَـرْشِـك ، وَمَلَائِكَتَكَ ، وَجَمـيعَ خَلْـقِك ، أَنَّـكَ أَنْـتَ اللهُ لا إلهَ إلاّ أَنْـتَ وَحْـدَكَ لا شَريكَ لَـك ، وَأَنَّ ُ مُحَمّـداً عَبْـدُكَ وَرَسـولُـك.َ",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  height: height * 0.2,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      color: Color(0xff434343),
                      borderRadius: BorderRadius.circular(12)),
                ),
              )
            ],
          ),
        ));
  }
}
