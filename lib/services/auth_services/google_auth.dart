import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthService {
  final BuildContext context;

  GoogleAuthService(this.context);

  void setupAuthListener() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        context.go('/bottom-nav');
      }
    });
  }

  Future<AuthResponse> googleSignIn() async {
    const webClientId =
        '718932252738-vuquuo0r0r1oprlbqcme8gsoteh6i3ud.apps.googleusercontent.com';

    const iosClientId =
        '718932252738-2g5hr3o31h79nghva5c10hdmscigacrq.apps.googleusercontent.com';

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted.');
      }
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw Exception('No Access Token found.');
      }
      if (idToken == null) {
        throw Exception('No ID Token found.');
      }

      return await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      // Log the error or handle it as needed
      print('Error during Google sign-in: $e');
      // Re-throw the exception for the calling function to handle it
      throw Exception('Failed to sign in with Google: $e');
    }
  }
}
// Example usage in another class:
// final googleAuthService = GoogleAuthService(context);
// googleAuthService.setupAuthListener();
// googleAuthService.googleSignIn();
