import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/user/ui/home_page.dart';
import 'package:lingap/features/virtual_consultation/user/ui/professional_card.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Map<String, dynamic>? appointment;
  Map<String, dynamic>? professional;
  SupabaseDB supabaseDB = SupabaseDB(client);
  bool isPending = false;

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
        if (result != null) {
          print('APPOINTMENT ${appointment!['status']}');
          getProfessional(result['professional_id']);
          isPending = appointment!['status'] == 'pending';
        }
      });
    }
  }

  String formatAppointment(String appointmentDate, String timeSlot) {
    // Parse the date string
    DateTime date = DateTime.parse(appointmentDate);

    // Format the date as "Month Day"
    String formattedDate = DateFormat("MMMM d").format(date);

    // Format the time slot (assumes timeSlot is in 24-hour format, e.g., "14:30")
    DateTime time = DateFormat("HH:mm").parse(timeSlot);
    String formattedTime =
        DateFormat("h:mm a").format(time); // Converts to "2:30 PM"

    return "You have an upcoming appointment on $formattedDate at $formattedTime.";
  }

  Future<void> getProfessional(String uid) async {
    Map<String, dynamic>? result =
        await supabaseDB.fetchReservedProfessional(uid);

    if (mounted) {
      setState(() {
        professional = result;
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
              appointment == null
                  ? 'assets/consultation/no_appointment.png'
                  : 'assets/consultation/upcoming.png',
              width: double.infinity,
              height: 280.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            appointment == null
                ? 'You have no therapist appointment'
                : appointment!['status'] == 'pending'
                    ? 'Your appointment is waiting for approval.'
                    : formatAppointment(appointment!['appointment_date'],
                        appointment!['time_slot']),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30.0,
                color: mindfulBrown['Brown80']),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30.0),

          if (professional != null)
            ProfessionalCard(professionalData: professional!),
          const SizedBox(height: 40.0),

          if (!isPending)
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (appointment == null) {
                    context.push('/findpage');
                  } else {
                    if (appointment!['status'] != 'pending') {
                      context.push('/instruction', extra: {
                        'roomId': appointment!['consultation_room'][0]
                            ['room_id'],
                        'name': professional!['name'],
                        'appointmentId': appointment!['id']
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mindfulBrown['Brown80'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  appointment == null ? 'Schedule Appointment' : 'Join call',
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
