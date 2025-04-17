import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/user/ui/professional_card.dart';

enum AppointmentState { none, pending, approved }

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Map<String, dynamic>? appointment;
  Map<String, dynamic>? professional;
  final SupabaseDB supabaseDB = SupabaseDB(client);

  @override
  void initState() {
    super.initState();
    _loadAppointment();
  }

  Future<void> _loadAppointment() async {
    final result = await supabaseDB.fetchReservedAppointment(uid);
    if (!mounted) return;

    setState(() {
      appointment = result;
      if (appointment != null) {
        supabaseDB
            .fetchReservedProfessional(appointment!['professional_id'])
            .then((prof) {
          if (mounted) setState(() => professional = prof);
        });
      }
    });
  }

  AppointmentState get _state {
    final status = appointment?['status'] as String?;
    if (appointment == null || status == 'completed') {
      return AppointmentState.none;
    }
    if (status == 'pending') {
      return AppointmentState.pending;
    }
    if (status == 'approved') {
      return AppointmentState.approved;
    }
    // fallback
    return AppointmentState.none;
  }

  String get _message {
    switch (_state) {
      case AppointmentState.pending:
        return 'Your appointment is awaiting approval.';
      case AppointmentState.approved:
        final date = appointment!['appointment_date'] as String;
        final slot = appointment!['time_slot'] as String;
        return formatAppointment(date, slot);
      case AppointmentState.none:
      default:
        return 'You have no appointment';
    }
  }

  bool get _showProfessionalCard =>
      _state == AppointmentState.pending || _state == AppointmentState.approved;

  bool get _showButton =>
      _state == AppointmentState.none || _state == AppointmentState.approved;

  String get _buttonText => _state == AppointmentState.approved
      ? 'Join call'
      : 'Schedule Appointment';

  void _onButtonPressed() {
    if (_state == AppointmentState.none) {
      context.push('/findpage');
    } else if (_state == AppointmentState.approved) {
      final room = appointment!['consultation_room'][0]['room_id'];
      final name = professional!['name'];
      final id = appointment!['id'];
      context.push('/instruction', extra: {
        'roomId': room,
        'name': name,
        'appointmentId': id,
      });
    }
  }

  String formatAppointment(String appointmentDate, String timeSlot) {
    final date = DateTime.parse(appointmentDate);
    final formattedDate = DateFormat("MMMM d").format(date);
    final time = DateFormat("HH:mm").parse(timeSlot);
    final formattedTime = DateFormat("h:mm a").format(time);
    return "You have an upcoming appointment on $formattedDate at $formattedTime.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // appointment image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                _state == AppointmentState.none
                    ? 'assets/consultation/no_appointment.png'
                    : 'assets/consultation/upcoming.png',
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),
            // status message
            Text(
              _message,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30,
                color: mindfulBrown['Brown80'],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),
            // professional card (only for pending or approved)
            if (_showProfessionalCard && professional != null)
              ProfessionalCard(professionalData: professional!),

            const SizedBox(height: 40),
            // action button (none & approved)
            if (_showButton)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mindfulBrown['Brown80'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _buttonText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
