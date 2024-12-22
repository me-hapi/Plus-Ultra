import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<void> uploadLicense({
    required String userId,
    required File frontImage,
    required File backImage,
  }) async {
    try {
      final frontStoragePath = 'professional_images/$userId/front.jpg';
      final backStoragePath = 'professional_images/$userId/back.jpg';

      final uploadResponses = await Future.wait([
        _client.storage.from('licenses').upload(frontStoragePath, frontImage),
        _client.storage.from('licenses').upload(backStoragePath, backImage),
      ]);

      final frontPublicUrl =
          _client.storage.from('licenses').getPublicUrl(frontStoragePath);
      final backPublicUrl =
          _client.storage.from('licenses').getPublicUrl(backStoragePath);

      final existingRecord = await _client
          .from('professional')
          .select('uid')
          .eq('uid', userId)
          .maybeSingle();

      if (existingRecord != null) {
        await _client.from('professional').update({
          'license_front': frontPublicUrl,
          'license_back': backPublicUrl,
        }).eq('uid', userId);
        print('Record updated successfully.');
      } else {
        await _client.from('professional').insert({
          'uid': userId,
          'license_front': frontPublicUrl,
          'license_back': backPublicUrl,
        });
        print('Record inserted successfully.');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> updateProfessional({
    required String uid,
    required Map<String, dynamic> stepData,
  }) async {
    try {
      final title = stepData['title'] ?? '';
      final fullName = stepData['fullName'] ?? '';
      final jobTitle = stepData['jobTitle'] ?? '';
      final bio = stepData['bio'] ?? '';
      final mobile = stepData['mobile'] ?? '';
      final email = stepData['email'] ?? '';

      final name = "$title $fullName";

      final response = await _client.from('professional').update({
        'name': name,
        'job': jobTitle,
        'bio': bio,
        'number': mobile,
        'email': email,
      }).eq('uid', uid);

      print('Professional record updated successfully.');
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> insertPaymentDetails({
    required String uid,
    required Map<String, dynamic> stepData,
  }) async {
    try {
      final isFreeConsultation = stepData['isFreeConsultation'] ?? false;
      final consultationFee =
          isFreeConsultation ? '0' : stepData['consultationFee'] ?? '';
      final gcashQrImage = isFreeConsultation ? null : stepData['gcashQrImage'];

      if (!isFreeConsultation && gcashQrImage == null) {
        throw Exception('GCash QR image is required for paid consultations.');
      }

      String? qrPublicUrl;
      if (!isFreeConsultation) {
        final qrStoragePath = 'payment_qr_codes/$uid/qr_code.jpg';

        final uploadResponse = await _client.storage.from('payment').upload(
              qrStoragePath,
              gcashQrImage!,
            );

        qrPublicUrl =
            _client.storage.from('payment').getPublicUrl(qrStoragePath);
      }

      final response = await _client.from('professional_payment').insert({
        'uid': uid,
        'consultation_fee': consultationFee,
        'payment_qr': qrPublicUrl,
      });

      print('Payment details inserted successfully.');
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> insertClinicDetails({
    required String uid,
    required Map<String, dynamic> stepData,
  }) async {
    try {
      // Check if teleconsultation is selected
      final teleconsultationOnly = stepData['teleconsultationOnly'] ?? false;

      // If teleconsultation is selected, set all fields to null
      final clinicName = teleconsultationOnly ? null : stepData['clinicName'];
      final clinicAddress =
          teleconsultationOnly ? null : stepData['clinicAddress'];
      final selectedLocation =
          teleconsultationOnly ? null : stepData['selectedLocation'];

      final clinicLat =
          selectedLocation != null ? selectedLocation['lat'] : null;
      final clinicLong =
          selectedLocation != null ? selectedLocation['lng'] : null;

      // Insert data into the professional_clinic table
      final response = await _client.from('professional_clinic').insert({
        'uid': uid,
        'clinic_name': clinicName,
        'clinic_address': clinicAddress,
        'clinic_lat': clinicLat,
        'clinic_long': clinicLong,
      });

      print('Clinic details inserted successfully.');
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> insertAvailabilityDetails({
    required String uid,
    required Map<String, dynamic> stepData,
  }) async {
    try {
      final availableDays = stepData['availableDays'] ?? [];
      final timeSlotData = stepData['timeSlotData'] ?? {};

      if (availableDays.isEmpty || timeSlotData.isEmpty) {
        throw Exception('Available days or time slot data cannot be empty.');
      }

      final List<Map<String, dynamic>> timeSlots = [];
      final List<List<dynamic>> breakTimes = [];

      for (var day in availableDays) {
        final dayData = timeSlotData[day];
        if (dayData == null) continue;

        timeSlots.add({
          'day': day,
          'start_time': dayData['start_time'],
          'end_time': dayData['end_time'],
        });

        breakTimes.add(dayData['break_time']);
      }

      // Insert data into professional_availability table
      final Map<String, dynamic> dataToInsert = {
        'uid': uid,
        'days': availableDays,
        'time_slot': timeSlots,
        'break_time': breakTimes,
      };

      final availabilityResponse =
          await _client.from('professional_availability').insert(dataToInsert);

      print('Availability details inserted successfully.');
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
