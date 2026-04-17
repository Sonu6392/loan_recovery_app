import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loan_recovery_app/utils/app_colour.dart';
import 'onboarding/introScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    //  5 seconds delay
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => IntroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 130,
                child: Image.asset("assets/logos/App1_logo.png",
                  fit: BoxFit.contain,),
              ),

              SizedBox(height: 30),
             CircularProgressIndicator(
               color: Color(0xff6330C6),
               strokeWidth: 3,
             )

            ],
          ),
        ),

    );
  }
}