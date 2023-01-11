import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:food_predator/components/high_scores_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyD3gBOgeEhnuk3OKAX8z2OoleVslRH6Pe8",
        authDomain: "snakegame-eb13b.firebaseapp.com",
        projectId: "snakegame-eb13b",
        storageBucket: "snakegame-eb13b.appspot.com",
        messagingSenderId: "695207282746",
        appId: "1:695207282746:web:35d5912eb0734c33d7cd03",
        measurementId: "G-R71CE0Y9ZW"),
  );
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HighScoresScreen(),
    );
  }
}
