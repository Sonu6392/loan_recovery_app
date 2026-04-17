import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/app_colour.dart';
import '../../bottom_navigation.dart';
import '../forget_password/forget_screen.dart';
import '../otp_verification.dart';

class LoginScreen extends StatefulWidget {

  final String initialTab;

  const LoginScreen({super.key, this.initialTab = "otp"});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {
  String selectedOption = "otp";
  bool isButtonEnabled = false;
  String phoneNumber = "";

  void updateButtonState(bool value) {
    setState(() {
      isButtonEnabled = value;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedOption = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.only(left: 16, right: 16, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Welcome!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              Text("Log in to Recovery Agent", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 17),

              //  Radio Row
              Row(
                children: [
                  CustomRadio(
                    isSelected: selectedOption == "otp",
                    onTap: () {
                      setState(() {
                        selectedOption = "otp";
                        isButtonEnabled = false;
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  Text("Mobile", style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14)),

                  SizedBox(width: 20),
                  CustomRadio(
                    isSelected: selectedOption == "email",
                    onTap: () {
                      setState(() {
                        selectedOption = "email";
                        isButtonEnabled = false;
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  Text("Email", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                ],
              ),

              SizedBox(height: 20),

              //  Dynamic UI
              if (selectedOption == "otp")
                OtpLoginWidget(
                  onChanged: updateButtonState,
                  onPhoneChanged: (value) {
                    phoneNumber = value;
                  }
                )
              else
                EmailLoginWidget(onChanged: updateButtonState),
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
              if (selectedOption == "otp") {
                //  OTP Verification Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  OtpVerification(type: "login", phoneNumber: phoneNumber),
                  ),
                );
              } else {

                //  BottomNavigation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigation(),
                  ),
                );
              }
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isButtonEnabled ? AppColors.primary :AppColors.inActiveButtonColour,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(selectedOption == "otp" ? "Get OTP" : "Log In", style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }
}



// CustomRadio
class CustomRadio extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CustomRadio({super.key, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade400, // Outer border color
            width: 2,
          ),
        ),
        child: Center(
          child: isSelected
              ? Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.black, // Inner dot color
              shape: BoxShape.circle,
            ),
          )
              : SizedBox(),
        ),
      ),
    );
  }
}


//  OTP LOGIN
class OtpLoginWidget extends StatefulWidget {

  final Function(bool) onChanged;
  final Function(String) onPhoneChanged;

  const OtpLoginWidget({super.key, required this.onChanged, required this.onPhoneChanged,});

  @override
  State<OtpLoginWidget> createState() => _OtpLoginWidgetState();
}
class _OtpLoginWidgetState extends State<OtpLoginWidget> {

  TextEditingController phoneController = TextEditingController();

  void checkValidation(String value) {
    widget.onChanged(value.length == 10);   // button enable/disable
    widget.onPhoneChanged(value);           //  number parent ko bhejna
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

        SizedBox(height: 10),
        Text("You will receive an OTP on this number", style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}


//  EMAIL LOGIN
class EmailLoginWidget extends StatefulWidget {
  final Function(bool) onChanged;

  const EmailLoginWidget({super.key, required this.onChanged});

  @override
  State<EmailLoginWidget> createState() => _EmailLoginWidgetState();
}
class _EmailLoginWidgetState extends State<EmailLoginWidget> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObscure = true;
  String? emailError;
  String? passwordError;

  final emailRegex =
  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  void validate() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    emailError = null;
    passwordError = null;

    if (email.isEmpty) {
      emailError = "Email required";
    } else if (!emailRegex.hasMatch(email)) {
      emailError = "Invalid email";
    }

    if (password.isEmpty) {
      passwordError = "Password required";
    } else if (password != "123456") {
      passwordError = "Wrong password";
    }

    bool isValid = emailError == null && passwordError == null;

    widget.onChanged(isValid);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // emailController
        TextField(
          controller: emailController,
          onChanged: (value) => validate(),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Enter Email Address",
            labelStyle: TextStyle(color: Colors.grey),
            floatingLabelStyle: TextStyle(color: Color(0xff6330C6)),
            errorText: emailError,
          ),
        ),
        SizedBox(height: 12),

        // passwordController
        TextField(
          controller: passwordController,
          onChanged: (value) => validate(),
          obscureText: isObscure,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            labelText: "Enter Password",
            labelStyle: TextStyle(color: Colors.grey),
            floatingLabelStyle: TextStyle(color: Color(0xff6330C6)),
            errorText: passwordError,
            suffixIcon: IconButton(
              icon: Icon(
                isObscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade400,
              ),
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
            ),
          ),
        ),

        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetScreen())
             );
            },
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: Color(0xff6330C6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

      ],
    );
  }
}