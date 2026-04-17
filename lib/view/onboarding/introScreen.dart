import 'dart:async';
import 'package:flutter/material.dart';
import '../../whole_widgets/assets_logo_widget.dart';
import '../../whole_widgets/custom_button.dart';
import '../auth/login/login_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  int currentIndex = 0;
  Timer? timer;

  List onboardingData = [
    {
      "title": "“Plan Your Visits Smarter”",
      "desc": "Get map directions to your recovery addresses and save time with optimized routes.",
    },
    {
      "title": "“View Your Daily Recovery Tasks”",
      "desc": "Get a clear view of your assigned recoveries, visits, and pending collections.",
    },
    {
      "title": "“Represent the Bank with Trust”",
      "desc": "Maintain professionalism during field visits and follow ethical recovery practices.",
    },
  ];

  @override
  void initState() {
    super.initState();

    //  AUTO TEXT CHANGE EVERY 2 SEC
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % onboardingData.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  //  DOT
  Widget buildDot(int index) {
    bool isActive = currentIndex == index;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Color(0xff6330C6) : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // FIXED IMAGE
            SizedBox(height: 20),
            AppLogo(),

            SizedBox(height: 80),

            //  ONLY TEXT CHANGE
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Column(
                key: ValueKey(currentIndex),
                children: [

                  //title
                  Text(
                    onboardingData[currentIndex]["title"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 10),

                  // desc
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      onboardingData[currentIndex]["desc"],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            //  DOTS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                    (index) => buildDot(index),
              ),
            ),

            Spacer(),

            //  FIXED BUTTON
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Get Started",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}