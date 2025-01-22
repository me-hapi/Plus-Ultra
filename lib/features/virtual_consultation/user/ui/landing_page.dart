import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/user/ui/home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Map<String, dynamic>? appointment;
  SupabaseDB supabaseDB = SupabaseDB(client);

  @override
  void initState() {
    super.initState();
    getAppointment();
  }

  Future<void> getAppointment() async {
    Map<String, dynamic>? result =
        await supabaseDB.fetchReservedAppointment(uid);
    if (mounted) {
      setState(() {
        appointment = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Displaying the image
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              'assets/consultation/no_appointment.png',
              width: double.infinity,
              height: 280.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'You have no therapist appointment',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36.0,
                color: mindfulBrown['Brown80']),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40.0),

          SizedBox(
            height: 55,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/findpage');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mindfulBrown['Brown80'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Schedule Appointment',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
