import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mymemberlink/views/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>  LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/animations/Animation_2.json",
            fit: BoxFit.contain,
            width: 300,
            height: 300, // Set your desired width
            // Set your desired height
            repeat: false, // Stops the animation after it finishes once
            onLoaded: (composition) {
              Future.delayed(const Duration(milliseconds: 3500), () {
                setState(() {});
              });
            },
          ),
          // To add space between Lottie animation and text
          // ignore: prefer_const_constructors
          Text(
            "MyMemberLink",
            style:
                GoogleFonts.sarina(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}