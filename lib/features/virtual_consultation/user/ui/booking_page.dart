import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/user/ui/booking/payment_page.dart';
import 'package:lingap/features/virtual_consultation/user/ui/landing_page.dart';
import 'package:lingap/features/virtual_consultation/user/ui/professional_card.dart';
import 'package:lingap/features/virtual_consultation/user/ui/booking/timedate.dart';
import 'package:lingap/features/virtual_consultation/user/ui/booking/user_details.dart';
import 'package:lingap/features/virtual_consultation/user/user_page.dart';
import 'package:lingap/modules/home/bottom_nav.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> professionalData;

  const BookingPage({
    Key? key,
    required this.professionalData,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int index = 0;
  final ScrollController _scrollController = ScrollController();
  SupabaseDB supabase = SupabaseDB(client);
  // late DateTime startTime;
  // late DateTime endTime;
  // late List<String> availableDays;
  // late List<String> breakTime;

  @override
  void initState() {
    super.initState();
    // fetchAvailability();
    print(widget.professionalData);

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void fetchAvailability() {
  //   startTime = widget.professionalData['start_time'];
  //   endTime = widget.professionalData['end_time'];
  //   availableDays = widget.professionalData['available_days'];
  //   breakTime = widget.professionalData['break_time'];
  // }

  final Map<String, dynamic> stepData = {
    'user_details': {},
    'time_date': {},
    'payment': {},
  };

  List<Widget> screens() {
    return [
      UserDetails(
        onDataChanged: (data) {
          stepData['user_details'] = data;
        },
      ),
      DateTimeSelector(
        onDataChanged: (data) {
          stepData['time_date'] = data;
        },
        startTime: widget.professionalData['start_time'],
        endTime: widget.professionalData['end_time'],
        availableDays: widget.professionalData['available_days'],
        breakTime: widget.professionalData['break_time'],
      ),
      PaymentPage(
        onDataChanged: (data) {
          stepData['payment'] = data;
        },
      ),
    ];
  }

  void nextPage() {
    print(stepData['time_date']);
    if (index < screens().length - 1) {
      setState(() {
        index++;
      });
      _scrollToTop();
    } else {
      supabase.insertAppointment(
          uid: uid,
          professionalUid: widget.professionalData['uid'],
          status: 'reserved');
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LandingPage(),
          ),
        );
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = ["User Details", "Time and Date", "Payment"];
    final professionalData = widget.professionalData;

    return Scaffold(
      backgroundColor: const Color(0xFFEBE7E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEBE7E4),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: const Icon(Icons.arrow_back, color: Colors.blueGrey),
          ),
        ),
        title: const Text(
          "Book Therapist",
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Pagination dots with labels
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  // Step indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(steps.length, (stepIndex) {
                      return Row(
                        children: [
                          _buildStep(isActive: stepIndex <= index),
                          if (stepIndex < steps.length - 1)
                            _buildConnectorLine(isActive: stepIndex <= index),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  // Step labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: steps.map((step) {
                      int stepIndex = steps.indexOf(step);
                      return SizedBox(
                        width:
                            80, // Matches the width of circle + line for alignment
                        child: Text(
                          step,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: stepIndex == index
                                ? Colors.blueGrey
                                : Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Professional Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ProfessionalCard(
                professionalData: professionalData,
              ),
            ),
            const SizedBox(height: 10),
            // Active Screen
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: screens()[index],
            ),
            const SizedBox(height: 16),
            // Custom Continue Button
            Center(
              child: GestureDetector(
                onTap: nextPage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Text(
                    index < steps.length - 1 ? 'Continue' : 'Finish',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({required bool isActive}) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blueGrey : Colors.grey,
      ),
    );
  }

  Widget _buildConnectorLine({required bool isActive}) {
    return Container(
      width: 80,
      height: 2,
      color: isActive ? Colors.blueGrey : Colors.grey,
    );
  }
}
