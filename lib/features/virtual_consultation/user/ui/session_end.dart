import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';

class SessionEndedPage extends StatelessWidget {
  final int appointmentId; // Accepts an integer parameter

  SessionEndedPage({required this.appointmentId});
  final SupabaseDB supabaseDB = SupabaseDB(client);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/consultation/finish.png',
                width: 350), // Ensure the image is in assets folder
            SizedBox(height: 20),
            Text(
              'Session Ended',
              style: TextStyle(
                color: mindfulBrown['Brown80'],
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your therapy session has ended.',
              style: TextStyle(
                color: optimisticGray['Gray50'],
                fontSize: 20,
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await supabaseDB.updateAppointment(appointmentId);
                  context.go('/bottom-nav', extra: 3);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mindfulBrown['Brown80'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'I understand',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
