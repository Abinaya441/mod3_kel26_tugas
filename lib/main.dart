import 'package:flutter/material.dart';
import 'package:mod3_kel26/screens/splash.dart';
import 'package:mod3_kel26/screens/home.dart';
import 'package:mod3_kel26/screens/detail.dart';
import 'package:mod3_kel26/screens/desc.dart';

void main() async {
  runApp(const AnimeApp());
}

class AnimeApp extends StatelessWidget {
  const AnimeApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime app',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
        '/detail': (context) => const DetailPage(item: 0, title: ''),
        '/desc': (context) => const DescPage(item: 0, title: '')
      },
    );
  }
}
