import 'package:flutter/material.dart';
import '../../../utils/app_colour.dart';
import '../login/login_screen.dart';

class CreatenewPassword extends StatefulWidget {
  const CreatenewPassword({super.key});

  @override
  State<CreatenewPassword> createState() => _CreatenewPasswordState();
}

class _CreatenewPasswordState extends State<CreatenewPassword> {

  String selectedOption = "otp";
  bool isButtonEnabled = false;

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

              Text("Create Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              Text("Create new password for your account", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              SizedBox(height: 20),

              CreatenewPasswordWidget(
                onChanged: (value) {
                  setState(() {
                    isButtonEnabled = value;
                  });
                },
              ),

            ],
          ),
        ),
      ),

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
              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.black.withOpacity(0.5),
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(20, 24, 20, 20),

                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🎉 Title
                        Text(
                          "🎉   Password changed Successfully",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),

                        SizedBox(height: 12),

                        // Subtitle
                        Text(
                          "Please login to your account with\nyour new password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.4,
                            decoration: TextDecoration.none,
                          ),
                        ),

                        SizedBox(height: 24),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pop(context);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => LoginScreen(initialTab: "email")),
                                    (Route<dynamic> route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Back to login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
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
            child: Text("Continue", style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }
}


//  EMAIL LOGIN
class CreatenewPasswordWidget extends StatefulWidget {
  final Function(bool) onChanged;

  const CreatenewPasswordWidget({super.key, required this.onChanged});

  @override
  State<CreatenewPasswordWidget> createState() => _CreatenewPasswordWidgetState();
}
class _CreatenewPasswordWidgetState extends State<CreatenewPasswordWidget> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isNewPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  void _checkButtonState() {
    String newPass = emailController.text.trim();
    String confirmPass = passwordController.text.trim();

    bool isValid =
        newPass.isNotEmpty &&
            confirmPass.isNotEmpty &&
            newPass == confirmPass;

    // 👇 parent ko value bhejo
    widget.onChanged(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text("New Password", style: TextStyle(color: AppColors.primary, fontSize: 14),),
        // New Password
        TextField(
          controller: emailController,
          obscureText: isNewPasswordObscure,
          obscuringCharacter: '*',
          onChanged: (value) {_checkButtonState();},

          decoration: InputDecoration(
            hintText: "Enter password",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            suffixIcon: IconButton(
              icon: Icon(
                isNewPasswordObscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade400,
              ),
              onPressed: () {
                setState(() {
                  isNewPasswordObscure = !isNewPasswordObscure;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 25),

        Text("Re-enter New Password", style: TextStyle(color: AppColors.primary,fontSize: 14),),
        // Re-enter New Password
        TextField(
          controller: passwordController,
          obscureText: isConfirmPasswordObscure,
          obscuringCharacter: '*',
          onChanged: (value) {_checkButtonState();},

          decoration: InputDecoration(
            hintText: "Enter password",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPasswordObscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade400,
              ),
              onPressed: () {
                setState(() {
                  isConfirmPasswordObscure = !isConfirmPasswordObscure;
                });
              },
            ),
          ),
        ),

        if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty && emailController.text != passwordController.text)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "Passwords do not match",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),


      ],
    );
  }
}
