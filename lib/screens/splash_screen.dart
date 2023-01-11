import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_predator/screens/animated_progress_indicator.dart';
import 'package:food_predator/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(milliseconds: 10700),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 50.0),
            child: Image.asset("assets/images/Logo.png"),
          ),
          const AnimatedLiquidLinearProgressIndicator(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Powered By "),
                Text(
                  "MangiSols",
                  style: TextStyle(color: Color(0xff24b04b)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
