import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashSCR(),
    );
  }
}

class SplashSCR extends StatefulWidget {
  const SplashSCR({super.key});

  @override
  State<SplashSCR> createState() => _SplashSCRState();
}

class _SplashSCRState extends State<SplashSCR> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SurahIndexSCR()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/quran.png")),
    );
  }
}

class ButtonScreen extends StatefulWidget {
  const ButtonScreen({super.key});

  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [ElevatedButton(onPressed: onPressed, child: child)],
      ),
    );
  }
}

class SurahIndexSCR extends StatefulWidget {
  const SurahIndexSCR({super.key});

  @override
  State<SurahIndexSCR> createState() => _SurahIndexSCRState();
}

class _SurahIndexSCRState extends State<SurahIndexSCR> {
  List<int> filteredIndexes = List.generate(
    quran.totalSurahCount,
    (i) => i + 1,
  );

  void filterSurahs(String type) {
    if (type == "Makkah") {
      filteredIndexes =
          List.generate(quran.totalSurahCount, (i) => i + 1)
              .where((surah) => quran.getPlaceOfRevelation(surah) == "Makkah")
              .toList();
    } else if (type == "Madinah") {
      filteredIndexes =
          List.generate(quran.totalSurahCount, (i) => i + 1)
              .where((surah) => quran.getPlaceOfRevelation(surah) == "Madinah")
              .toList();
    } else {
      // Reset to all
      filteredIndexes = List.generate(quran.totalSurahCount, (i) => i + 1);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => filterSurahs("Makkah"),
                child: Text("Makki (86)"),
              ),
              ElevatedButton(
                onPressed: () => filterSurahs("Madinah"),
                child: Text("Madni (28)"),
              ),
              ElevatedButton(
                onPressed: () => filterSurahs("All"),
                child: Text("All"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredIndexes.length,
              itemBuilder: (context, index) {
                int surahNumber = filteredIndexes[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailSurah(surahNumber),
                      ),
                    );
                  },
                  leading: CircleAvatar(child: Text("$surahNumber")),
                  title: Text(
                    quran.getSurahNameArabic(surahNumber),
                    style: GoogleFonts.amiriQuran(),
                  ),
                  subtitle: Text(
                    quran.getSurahNameEnglish(surahNumber),
                    style: GoogleFonts.amiriQuran(),
                  ),
                  trailing: Column(
                    children: [
                      quran.getPlaceOfRevelation(surahNumber) == "Makkah"
                          ? Image.asset(
                            "assets/images/kaaba.png",
                            width: 30,
                            height: 30,
                          )
                          : Image.asset(
                            "assets/images/madina.png",
                            width: 30,
                            height: 30,
                          ),
                      Text("Verses ${quran.getVerseCount(surahNumber)}"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailSurah extends StatefulWidget {
  final int surahNumber;
  DetailSurah(this.surahNumber, {super.key});

  @override
  State<DetailSurah> createState() => _DetailSurahState();
}

class _DetailSurahState extends State<DetailSurah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(quran.getSurahName(widget.surahNumber))),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: quran.getVerseCount(widget.surahNumber),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  quran.getVerse(
                    widget.surahNumber,
                    index + 1,
                    verseEndSymbol: true,
                  ),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiriQuran(),
                ),
                subtitle: Text(
                  quran.getVerseTranslation(
                    widget.surahNumber,
                    translation: quran.Translation.urdu,
                    index + 1,
                  ),
                  textAlign: TextAlign.right,
                  style: TextStyle(fontFamily: "jameel"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
