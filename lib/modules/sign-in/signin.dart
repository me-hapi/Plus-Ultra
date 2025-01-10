import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignPage extends ConsumerStatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  final GlobalSupabase supabase = GlobalSupabase(client);

  void _sendOtp(String email) async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(
          email: email);
      setState(() {
        _isOtpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP has been sent to your email."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send OTP: \$e"),
        ),
      );
    }
  }

  void _verifyOtp(String email, String otp) async {
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.magiclink,
      );
      if (response.user != null) {
        context.go('/bottom-nav');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to verify OTP"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error verifying OTP: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: const Color(0xFF059212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SupaEmailAuth(
                redirectTo: 'io.supabase.lingap://login-callback/',
                onSignInComplete: (response) {
                  _sendOtp(response.user!.email!);
                },
                onSignUpComplete: (response) async {
                  final user = response.user;
                  if (user != null) {
                    final uid = user.id;
                    final name = user.userMetadata?['username'] ?? '';
                    await supabase.insertProfile(uid: uid, name: name);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("Please check your email for verification."),
                    ),
                  );
                  _sendOtp(response.user!.email ?? '');
                },
                metadataFields: [
                  MetaDataField(
                    prefixIcon:
                        const Icon(Icons.person, color: Color(0xFF059212)),
                    label: 'Username',
                    key: 'username',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter something';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              if (_isOtpSent) ...[
                TextField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF059212)),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final otp = _otpController.text;
                    if (otp.isNotEmpty) {
                      _verifyOtp(
                          Supabase.instance.client.auth.currentUser?.email ??
                              '',
                          otp);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter the OTP."),
                        ),
                      );
                    }
                  },
                  child: const Text('Verify OTP'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
