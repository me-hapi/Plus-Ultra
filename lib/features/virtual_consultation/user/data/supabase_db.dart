import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<List<Map<String, dynamic>>> fetchProfessionals() async {
    try {
      // Perform the join query using Supabase
      final response = await _client.from('professional').select(
          '*, professional_payment(*), professional_clinic(*), professional_availability(*)');

      // Parse and return the data
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching joined data: $e');
      return [];
    }
  }

  Future<void> insertAppointment({
    required String uid,
    required String professionalUid,
    required String status,
    required Map<String, dynamic> stepData,
  }) async {
    try {
      final createdAt = DateTime.now().toIso8601String();

      // Extract user_details and time_date from stepData
      final userDetails = stepData['user_details'] as Map<String, dynamic>;
      final timeDate = stepData['time_date'] as Map<String, dynamic>;

      // Convert DateTime objects to ISO8601 strings
      final birthDate =
          (userDetails['birthDate'] as DateTime).toIso8601String();
      final appointmentDate =
          (timeDate['selectedDate'] as DateTime).toIso8601String();

      final response = await _client.from('appointment').insert({
        'created_at': createdAt,
        'uid': uid,
        'professional_id': professionalUid,
        'status': status,
        // User Details
        'full_name': userDetails['fullName'],
        'email': userDetails['email'],
        'mobile': userDetails['mobile'],
        'gender': userDetails['gender'],
        'weight': userDetails['weight'],
        'height': userDetails['height'],
        'birthdate': birthDate, // Use ISO8601 string
        'comment': userDetails['comments'],
        // Date and timeslot
        'appointment_date': appointmentDate, // Use ISO8601 string
        'time_slot': timeDate['selectedTimeSlot'],
      });

      print('Appointment inserted successfully!');
    } catch (e) {
      print('Error inserting appointment: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchReservedAppointment(String uid) async {
    try {
      final response = await _client
          .from('appointment')
          .select()
          .eq('uid', uid)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchAppointmentHistory() async {
    final supabase = Supabase.instance.client;

    try {
      // Fetch appointments with related professional details
      final response = await supabase.from('appointment').select(
          'appointment_date, status, professional:professional_id(name, uid)');

      final appointments = response as List;

      // Group data by professional name
      final Map<String, Map<String, dynamic>> groupedData = {};

      for (var appointment in appointments) {
        final professional = appointment['professional'];
        final professionalName = professional['name'];
        final date = appointment['appointment_date'];
        final status = appointment['status'];

        if (!groupedData.containsKey(professionalName)) {
          // Initialize a new group for the professional
          groupedData[professionalName] = {
            'name': professionalName,
            'dates': [
              {'date': date, 'status': status}
            ]
          };
        } else {
          // Add new date and status to the existing group
          groupedData[professionalName]!['dates']
              .add({'date': date, 'status': status});
        }
      }

      // Prepare final merged result
      final List<Map<String, dynamic>> mergedResults = groupedData.entries
          .map((entry) => {
                'name': entry.value['name'],
                'dates': entry.value['dates'], // List of dates and statuses
              })
          .toList();

      return mergedResults;
    } catch (e) {
      return null;
    }
  }
}
