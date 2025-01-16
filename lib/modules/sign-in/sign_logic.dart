import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignLogic {
  final SupabaseClient _supabaseClient;

  SignLogic(this._supabaseClient);

  /// Signs up a user and sends OTP to the email.
  Future<bool> signUpWithEmail(
      String email, String password, BuildContext context) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // OTP sent to the email. Inform the user.
        _showSnackBar(context, "An OTP has been sent to your email.");
        return true;
      } else {
        _showSnackBar(context, "Signup failed.");
        return false;
      }
    } catch (e) {
      _showSnackBar(context, "An error occurred: $e");
      print(e);
      return false;
    }
  }

  /// Verifies the OTP entered by the user.
  Future<String> verifySignupOTP(
      String email, String otpCode, BuildContext context) async {
    try {
      final response = await _supabaseClient.auth.verifyOTP(
        email: email,
        token: otpCode,
        type: OtpType.signup,
      );

      if (response.user != null) {
        final user = response.user;
        final uid = user!.id;
        _showSnackBar(context, "OTP verified successfully. Signup complete.");
        return uid;
      } else {
        _showSnackBar(context, "OTP verification failed.");
        return '';
      }
    } catch (e) {
      _showSnackBar(context, "An error occurred: $e");
      return '';
    }
  }

  /// Resends OTP to the user's email.
  Future<void> resendOTP(String email, BuildContext context) async {
    try {
      final response = await _supabaseClient.auth.resend(
        email: email,
        type: OtpType.signup,
      );
      _showSnackBar(context, "OTP has been resent to your email.");
    } catch (e) {
      _showSnackBar(context, "An error occurred: $e");
      print(e);
    }
  }

  /// Signs in a user with email and password.
  Future<bool> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      final response = await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      return true;
    } catch (e) {
      _showSnackBar(context, "An error occurred: $e");
      print(e);
      return false;
    }
  }

  /// Displays a snackbar with a message.
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
