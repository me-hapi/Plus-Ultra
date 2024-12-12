import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
    _checkSession();
  }

  void _checkSession() async {
    final Session? session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return;

    Future.microtask(() {
      if (session != null) {
        context.go('/bottom-nav');
      } else {
        context.go('/intro');
      }
    });
  }

  _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3), () {});
    if (!mounted) return;

    Future.microtask(() {
      context.go('/intro');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                ),
                Transform.translate(
                  offset: Offset(0, -15), // Moves the text upwards by 10 pixels
                  child: Text(
                    'Lingap',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CC9FE)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
