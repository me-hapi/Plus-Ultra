import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/const/loading_screen.dart';
import 'package:lingap/features/virtual_consultation/professional/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/steps/successful_modal.dart';

class ApplicationLogic {
  final BuildContext context;
  final SupabaseDB supabaseDB;
  final Map<String, dynamic> stepData;
  final List<String> steps;
  int currentIndex;

  ApplicationLogic({
    required this.context,
    required this.supabaseDB,
    required this.stepData,
    required this.steps,
    this.currentIndex = 0,
  });

  void previousPage() {
    currentIndex--;
  }

  Future<void> nextPage() async {
    if (!validateCurrentStep()) return;
    print(stepData['verification']);
    print(stepData['payment']);
    print(stepData['clinic']);
    print(stepData['availability']);

    if (currentIndex < steps.length - 1) {
      currentIndex++;
    } else {
      await submitApplication();
    }
  }

  bool validateCurrentStep() {
    switch (currentIndex) {
      case 0:
        final verificationData = stepData['verification'];
        if (verificationData == null ||
            verificationData['frontImage'] == null ||
            verificationData['backImage'] == null) {
          _showSnackBar(
              "Please upload both front and back ID images to continue.");
          return false;
        }
        break;
      case 1:
        final informationData = stepData['information'];
        if (!_validateInformation(informationData)) return false;
        break;
      case 2:
        final paymentData = stepData['payment'];
        if (!_validatePayment(paymentData)) return false;
        break;
      case 3:
        final clinicData = stepData['clinic'];
        if (!_validateClinic(clinicData)) return false;
        break;
      case 4:
        final availabilityData = stepData['availability'];
        if (!_validateAvailability(availabilityData)) return false;
        break;
    }
    return true;
  }

  Future<void> submitApplication() async {
    LoadingScreen.show(context);
    await supabaseDB.uploadLicense(
      userId: uid,
      frontImage: stepData['verification']['frontImage'],
      backImage: stepData['verification']['backImage'],
    );
    await supabaseDB.updateProfessional(
        uid: uid, stepData: stepData['information']);
    await supabaseDB.insertPaymentDetails(
        uid: uid, stepData: stepData['payment']);
    await supabaseDB.insertClinicDetails(
        uid: uid, stepData: stepData['clinic']);
    await supabaseDB.insertAvailabilityDetails(
        uid: uid, stepData: stepData['availability']);

    LoadingScreen.hide(context);
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) => Dialog(
        backgroundColor:
            Colors.transparent, // Makes dialog background transparent
        child: SuccessfulModal(),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _validateInformation(Map<dynamic, dynamic>? informationData) {
    if (informationData == null ||
        informationData['title'] == null ||
        informationData['title'].isEmpty ||
        informationData['fullName'] == null ||
        informationData['fullName'].isEmpty ||
        informationData['jobTitle'] == null ||
        informationData['jobTitle'].isEmpty ||
        informationData['bio'] == null ||
        informationData['bio'].isEmpty ||
        informationData['mobile'] == null ||
        informationData['mobile'].isEmpty ||
        informationData['email'] == null ||
        informationData['email'].isEmpty) {
      _showSnackBar("Please fill out all fields to continue.");
      return false;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(informationData['mobile'])) {
      _showSnackBar("Please enter a valid mobile number.");
      return false;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(informationData['email'])) {
      _showSnackBar("Please enter a valid email address.");
      return false;
    }

    return true;
  }

  bool _validatePayment(Map<dynamic, dynamic>? paymentData) {
    if (paymentData == null || paymentData['isFreeConsultation'] == null) {
      _showSnackBar("Please select if consultation is free or paid.");
      return false;
    }

    if (paymentData['isFreeConsultation'] == false) {
      if (paymentData['consultationFee'] == null ||
          paymentData['consultationFee'].isEmpty) {
        _showSnackBar("Please enter a consultation fee.");
        return false;
      }
    }
    return true;
  }

  bool _validateClinic(Map<dynamic, dynamic>? clinicData) {
    if (clinicData == null || clinicData['teleconsultationOnly'] == null) {
      _showSnackBar("Please specify if teleconsultation only or not.");
      return false;
    }

    if (clinicData['teleconsultationOnly'] == false) {
      if (clinicData['clinicName'] == null ||
          clinicData['clinicName'].isEmpty) {
        _showSnackBar("Please enter the clinic name.");
        return false;
      }
      if (clinicData['clinicAddress'] == null ||
          clinicData['clinicAddress'].isEmpty) {
        _showSnackBar("Please enter the clinic address.");
        return false;
      }
      if (clinicData['selectedLocation'] == null) {
        _showSnackBar("Please select a clinic location.");
        return false;
      }
    }
    return true;
  }

  bool _validateAvailability(Map<dynamic, dynamic>? availabilityData) {
    if (availabilityData == null ||
        availabilityData['availableDays'] == null ||
        availabilityData['availableDays'].isEmpty ||
        availabilityData['timeSlotData'] == null) {
      _showSnackBar("Please provide all required availability details.");
      return false;
    }

    final availableDays = availabilityData['availableDays'] as List<String>;
    final timeSlotData =
        availabilityData['timeSlotData'] as Map<String, Map<String, dynamic>>;

    for (var day in availableDays) {
      if (!timeSlotData.containsKey(day)) {
        _showSnackBar("Missing time slot details for $day.");
        return false;
      }

      final dayData = timeSlotData[day];
      final String? startTime = dayData!['start_time'];
      final String? endTime = dayData['end_time'];
      final List<dynamic>? breakTimes = dayData['break_time'];

      if (startTime == null || endTime == null) {
        _showSnackBar("Start time and end time must be provided for $day.");
        return false;
      }

      if (!_isValidTimeRange(startTime, endTime)) {
        _showSnackBar("Start time must be before end time for $day.");
        return false;
      }

      if (breakTimes != null) {
        for (var breakTime in breakTimes) {
          if (!_isTimeInRange(breakTime, startTime, endTime)) {
            _showSnackBar(
                "Break time $breakTime must be within start and end time for $day.");
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Helper function to check if start and end times are valid
  bool _isValidTimeRange(String startTime, String endTime) {
    final startPeriod = startTime.split(' ').last;
    final endPeriod = endTime.split(' ').last;

    if (startPeriod == 'AM' && endPeriod == 'PM') {
      return true; // Automatically valid if start is AM and end is PM
    }

    if (startPeriod == endPeriod) {
      // Compare actual times if both are in the same period (AM/PM)
      return _convertTimeToMinutes(startTime) < _convertTimeToMinutes(endTime);
    }

    return false;
  }

  /// Helper function to check if a time is within a range
  bool _isTimeInRange(String time, String startTime, String endTime) {
    final timeMinutes = _convertTimeToMinutes(time);
    final startMinutes = _convertTimeToMinutes(startTime);
    final endMinutes = _convertTimeToMinutes(endTime);

    return startMinutes <= timeMinutes && timeMinutes <= endMinutes;
  }

  /// Helper function to convert time strings (e.g., "8:00 AM") to minutes
  int _convertTimeToMinutes(String time) {
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1] == 'PM';

    // Handle 12:00 PM and 12:00 AM explicitly
    if (hour == 12 && isPM) {
      return 12 * 60 + minute; // 12:00 PM is 720 minutes
    } else if (hour == 12 && !isPM) {
      return minute; // 12:00 AM is 0 minutes
    }

    return (isPM ? hour + 12 : hour) * 60 + minute;
  }
}
