// booking_logic.dart (Backend)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/const/loading_screen.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/user/services/api_service.dart';
import 'package:lingap/features/virtual_consultation/user/ui/landing_page.dart';

class BookingLogic {
  final ScrollController scrollController;
  final SupabaseDB supabase;
  final Map<String, dynamic> professionalData;
  final Map<String, dynamic> stepData = {
    'user_details': {},
    'time_date': {},
  };

  int index = 0;

  BookingLogic({
    required this.scrollController,
    required this.professionalData,
    required this.supabase,
  });

  Future<void> nextPage(
      BuildContext context, VoidCallback onUpdateIndex) async {
    if (index == 0 && !_validateUserDetails()) {
      _showValidationError(context,
          'Please fill in all required fields correctly in User Details.');
      return;
    }

    if (index == 1 && !_validateDateTime()) {
      _showValidationError(
          context, 'Please select a valid date and time slot.');
      return;
    }

    if (index < 2) {
      index++;
      _scrollToTop();
      onUpdateIndex();
    } else {
      print(stepData);

      LoadingScreen.show(context);
      supabase.insertAppointment(
          uid: uid,
          status: 'pending',
          stepData: stepData,
          professionalUid: professionalData['uid']);

      String roomId = await APIService().createRoomId();
      supabase.insertRoom(
          uid: uid, professionalUid: professionalData['uid'], roomId: roomId);

      LoadingScreen.hide(context);
      context.push('/bottom-nav', extra: 3);
    }
  }

  void _scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  bool _validateUserDetails() {
    final userDetails = stepData['user_details'];
    return userDetails['fullName'] != null &&
        userDetails['fullName'].trim().isNotEmpty &&
        userDetails['email'] != null &&
        userDetails['email'].contains('@') &&
        userDetails['mobile'] != null &&
        userDetails['mobile'].trim().isNotEmpty &&
        userDetails['gender'] != null &&
        userDetails['gender'].trim().isNotEmpty &&
        userDetails['comments'] != null;
  }

  bool _validateDateTime() {
    final timeDate = stepData['time_date'];
    return timeDate['selectedDate'] != null &&
        timeDate['selectedTimeSlot'] != null &&
        timeDate['selectedDate'].isAfter(DateTime.now());
  }

  void _showValidationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
