import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
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
      backgroundColor: mindfulBrown['Brown10'],
      appBar: AppBar(
        backgroundColor: mindfulBrown['Brown10'],
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(Icons.arrow_back, color: mindfulBrown['Brown80']),
          ),
        ),
        title: Text(
          "Book Therapist",
          style: TextStyle(
            color: mindfulBrown['Brown80'],
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
                          _buildStep(
                            isPreviousActive: stepIndex < bookingLogic.index,
                            isCurrentActive: stepIndex <= bookingLogic.index,
                          ),
                          if (stepIndex < steps.length - 1)
                            _buildConnectorLine(
                              isPreviousActive: stepIndex <= bookingLogic.index,
                              isCurrentActive:
                                  stepIndex + 1 <= bookingLogic.index,
                            )
                          // if (stepIndex < steps.length - 1)
                          //   _buildConnectorLine(
                          //       isActive: stepIndex <= bookingLogic.index),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  // Step labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: steps.map((step) {
                      int stepIndex = steps.indexOf(step);
                      return SizedBox(
                        width: 130,
                        child: Text(
                          step,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: stepIndex == bookingLogic.index
                                ? mindfulBrown['Brown80']
                                : mindfulBrown['Brown30'],
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    bookingLogic.nextPage(context, () {
                      setState(() {});
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mindfulBrown['Brown80'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    bookingLogic.index < steps.length - 1
                        ? 'Continue'
                        : 'Finish',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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

  Widget _buildStep({
    required bool isPreviousActive,
    required bool isCurrentActive,
  }) {
    return Container(
      width: isPreviousActive
          ? 32
          : isCurrentActive
              ? 39
              : 32,
      height: isPreviousActive
          ? 32
          : isCurrentActive
              ? 39
              : 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrentActive
            ? serenityGreen['Green50']
            : isPreviousActive
                ? serenityGreen['Green50']
                : Colors.transparent,
        border: Border.all(
          width: isCurrentActive ? 4 : 2,
          color: isPreviousActive
              ? Colors.transparent
              : isCurrentActive
                  ? serenityGreen['Green30']!
                  : mindfulBrown['Brown30']!,
        ),
      ),
      child: isPreviousActive
          ? Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            )
          : isCurrentActive
              ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mindfulBrown['Brown30'],
                    ),
                  ),
                ),
    );
  }

  Widget _buildConnectorLine({
    required bool isPreviousActive,
    required bool isCurrentActive,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 2,
          color: isPreviousActive
              ? serenityGreen['Green50']
              : mindfulBrown['Brown30'],
        ),
        Container(
          width: 50,
          height: 2,
          color: isCurrentActive
              ? serenityGreen['Green50']
              : mindfulBrown['Brown30'],
        ),
      ],
    );
  }
}
