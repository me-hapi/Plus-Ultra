import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/modules/sign-in/sign_logic.dart';

class OTPSetupPage extends StatefulWidget {
  final String email;

  OTPSetupPage({required this.email});

  @override
  _OTPSetupPageState createState() => _OTPSetupPageState();
}

class _OTPSetupPageState extends State<OTPSetupPage> {
  final SignLogic signLogic = SignLogic(client);
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'OTP Setup',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        leadingWidth: 200, // Adjust the width to fit text beside the arrow
        elevation: 0,
        backgroundColor: Colors.transparent, // Remove app bar background
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40), // Adjust to lower the title area
            Text(
              'Enter 6 digit OTP Code',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Please enter the 6 digit code you received from your email',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  6, (index) => _buildOTPInputField(context, index)),
            ),
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final otpCode = _controllers
                        .map((controller) => controller.text)
                        .join();

                    if (await signLogic.verifySignupOTP(
                        widget.email, otpCode, context)) {
                      context.go('/dastest');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        mindfulBrown['Brown80'], // Set background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold, // Optional for emphasis
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the OTP? ",
                  style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w700,
                      color: optimisticGray['Gray60']!),
                ),
                GestureDetector(
                  onTap: () {
                    // Add your resend logic here
                  },
                  child: Text(
                    'Resend',
                    style: TextStyle(
                        color: serenityGreen['Green50']!,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPInputField(BuildContext context, int index) {
    return Container(
      width: 50,
      height: 70,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index], // Attach the FocusNode
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          color: _focusNodes[index].hasFocus ? Colors.green : Colors.brown,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: _focusNodes[index].hasFocus
              ? Colors.green.withOpacity(0.1)
              : Colors.white,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(20), // Ensure rounded corners always
            borderSide: _focusNodes[index].hasFocus
                ? BorderSide(
                    color: serenityGreen['Green50']!,
                    width: 3.0, // Thicker border if focused
                  )
                : BorderSide.none, // No visible border if not focused
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: serenityGreen['Green50']!,
              width: 3.0, // Thicker border on focus
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide.none, // No visible border but rounded corners
          ),
          counterText: '', // Removes the counter text
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }
}
