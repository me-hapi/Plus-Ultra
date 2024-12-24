import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/logic/booking_logic.dart';
import 'package:lingap/features/virtual_consultation/user/ui/booking/payment_page.dart';
import 'package:lingap/features/virtual_consultation/user/ui/professional_card.dart';
import 'package:lingap/features/virtual_consultation/user/ui/booking/datetime_page.dart';
import 'package:lingap/features/virtual_consultation/user/ui/booking/user_details.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';

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
  late BookingLogic bookingLogic;

  @override
  void initState() {
    super.initState();
    bookingLogic = BookingLogic(
      scrollController: ScrollController(),
      professionalData: widget.professionalData,
      supabase: SupabaseDB(client),
    );
  }

  @override
  void dispose() {
    bookingLogic.scrollController.dispose();
    super.dispose();
  }

  List<Widget> screens() {
    return [
      UserDetails(
        onDataChanged: (data) {
          bookingLogic.stepData['user_details'] = data;
        },
      ),
      DateTimePage(
        onDataChanged: (data) {
          bookingLogic.stepData['time_date'] = data;
        },
        timeSlot: widget.professionalData['professional_availability']
            ['time_slot'],
        availableDays: widget.professionalData['professional_availability']
            ['days'],
        breakTime: widget.professionalData['professional_availability']
            ['break_time'],
      ),
      PaymentPage(),
    ];
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
        controller: bookingLogic.scrollController,
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
                          _buildStep(isActive: stepIndex <= bookingLogic.index),
                          if (stepIndex < steps.length - 1)
                            _buildConnectorLine(
                                isActive: stepIndex <= bookingLogic.index),
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
                        width: 80,
                        child: Text(
                          step,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: stepIndex == bookingLogic.index
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
              child: screens()[bookingLogic.index],
            ),
            const SizedBox(height: 16),
            // Custom Continue Button
            Center(
              child: GestureDetector(
                onTap: () {
                  bookingLogic.nextPage(context, () {
                    setState(() {});
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Text(
                    bookingLogic.index < steps.length - 1
                        ? 'Continue'
                        : 'Finish',
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
