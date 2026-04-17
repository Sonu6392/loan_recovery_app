import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bottom_navigation.dart';
import 'forget_password/createnew_password.dart';

class OtpVerification extends StatefulWidget {
  final String type;
  final String phoneNumber;

  const OtpVerification({super.key, required this.type, required this.phoneNumber});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {

  final String _correctOtp = "1234";
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isOtpIncorrect = false;

  // Countdown variables
  int _secondsRemaining = 30;
  Timer? _timer;
  bool _canResend = false; // New variable

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 30;
      _canResend = false; // Disable resend at start
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true; // Enable resend when timer hits 0
        });
      }
    });
  }

  bool isFilled(int index) {
    return _controllers[index].text.isNotEmpty;
  }

  void _checkOtp() {
    String enteredOtp = _controllers.map((e) => e.text).join();

    if (enteredOtp == _correctOtp) {
      setState(() {
        _isOtpIncorrect = false;
      });

      if (widget.type == "login") {

        //  LOGIN FLOW
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottomNavigation()),
        );
      } else if (widget.type == "forget") {

        //  FORGET PASSWORD FLOW
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CreatenewPassword()),
        );
      }

    } else {
      setState(() {
        _isOtpIncorrect = true;
      });
    }
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 50,
      child:Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {

            if (_controllers[index].text.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
              _controllers[index - 1].clear();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,

          style: TextStyle(
            color: _isOtpIncorrect ? Colors.red : Colors.black,
            fontWeight: FontWeight.bold,
          ),

          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: Colors.grey.shade200,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isOtpIncorrect ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isOtpIncorrect ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isOtpIncorrect ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),
          ),

          onChanged: (value) {
            setState(() {}); // 🔥 UI refresh for error remove/show

            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            }

            String currentOtp = _controllers.map((c) => c.text).join();

            /// 👉 ONLY reset error when user starts typing again
            if (currentOtp.isNotEmpty && _isOtpIncorrect) {
              setState(() {
                _isOtpIncorrect = false;
              });
            }

            if (currentOtp.length == 4) {
              _checkOtp();
            }
          },
        ),
      )
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controllers.forEach((c) => c.dispose());
    _focusNodes.forEach((f) => f.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("OTP Verification", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),

            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "We’ve sent OTP to your mobile number at ",
                    style: TextStyle(color: Colors.black, fontSize: 13, height: 1.5),
                  ),
                  TextSpan(
                      text: "${widget.phoneNumber} ",
                    style: TextStyle(color: Color(0xff6330C6), fontSize: 13, height: 1.5),
                  ),
                  TextSpan(
                    text: "Please enter 4 digits code you receive.",
                    style: TextStyle(color: Colors.black, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
            Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 22),
                    child: _buildOtpBox(index),
                  ),
                );
              }),
            ),
            if (_isOtpIncorrect)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Incorrect OTP", style: TextStyle(color: Colors.red)),
              ),

            SizedBox(height: 25),
            Center(
              child: Column(
                children: [
                  
                  Text("Didn’t receive code?", style: TextStyle( color: Colors.black54),),
                  SizedBox(height: 13),

                  // Timer text
                  Text(
                    "Resend in $_secondsRemaining s",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 4),

                  // Resend Code button
                  TextButton(
                    onPressed: _secondsRemaining == 0 ? _startCountdown : null, // Enabled only when timer = 0
                    child: Text(
                      "Resend Code",
                      style: TextStyle(
                        color: _secondsRemaining == 0 ? Color(0xff6330C6) : Colors.grey, // Greyed out when disabled
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Simple HomePage placeholder
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Home Page",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}