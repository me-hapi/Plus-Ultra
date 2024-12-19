import 'package:flutter/material.dart';
import 'package:lingap/features/virtual_consultation/user/ui/home_page.dart';
import 'package:lingap/features/virtual_consultation/user/ui/landing_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LandingPage(),
    );
  }
}
