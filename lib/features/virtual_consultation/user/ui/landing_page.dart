import 'package:flutter/material.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the image
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                'assets/test.jpg',
                width: double.infinity,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20.0),
            // Display message and button based on appointment state
            if (appointment == null) ...[
              const Text(
                'You have no therapist appointment',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: const Text('Schedule Appointment'),
              ),
            ] else ...[
              const Text(
                'Upcoming Appointment',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Add logic to join the call
                },
                child: const Text('Join Call'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
