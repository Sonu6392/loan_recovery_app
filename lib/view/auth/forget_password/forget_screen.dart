import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/app_colour.dart';
import '../otp_verification.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});
  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  String selectedOption = "otp";
  bool isButtonEnabled = false;
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Forget Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              Text("Please enter your mobile number to get OTP", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              SizedBox(height: 17),

              ForgetScreenWidget(
                onChanged: (value) {
                  setState(() {
                    isButtonEnabled = value;
                  });
                },
                onPhoneChanged: (value) {
                  phoneNumber = value; //  ab yaha store ho raha hai
                },
              ),

            ],
          ),
        ),
      ),

      //  BUTTON (keyboard ke upar ayega)
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 40,
          top: 10,
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isButtonEnabled
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerification(type: "forget",phoneNumber: phoneNumber,),
                ),
              );
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isButtonEnabled
                  ? AppColors.primary
                  : AppColors.inActiveButtonColour,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Get OTP", style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}


//  OTP LOGIN
class ForgetScreenWidget extends StatefulWidget {
  final Function(bool) onChanged;
  final Function(String) onPhoneChanged;

  const ForgetScreenWidget({super.key, required this.onChanged, required this.onPhoneChanged,});

  @override
  State<ForgetScreenWidget> createState() => _ForgetScreenWidgetState();
}
class _ForgetScreenWidgetState extends State<ForgetScreenWidget> {

  TextEditingController phoneController = TextEditingController();

  void checkValidation(String value) {
    widget.onChanged(value.length == 10);
    widget.onPhoneChanged(value); //  yaha number bhejna hai
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text("Mobile Number", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff6330C6))),

        TextField(
          controller: phoneController,
          keyboardType: TextInputType.number,
          maxLength: 10,
          onChanged: checkValidation,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 3, right: 4,),
              child: Text("+91", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 0),
            counterText: "",
          ),
        ),

      ],
    );
  }
}


