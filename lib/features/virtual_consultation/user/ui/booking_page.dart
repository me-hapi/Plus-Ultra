import 'package:flutter/material.dart';
import 'package:lingap/features/virtual_consultation/user/ui/payment_page.dart';
import 'package:lingap/features/virtual_consultation/user/ui/professional_card.dart';
import 'package:lingap/features/virtual_consultation/user/ui/timedate.dart';
import 'package:lingap/features/virtual_consultation/user/ui/user_details.dart';

class BookingPage extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String job;
  final String location;
  final String distance;

  const BookingPage({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.job,
    required this.location,
    required this.distance,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int index = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> screens() {
    return [
      UserDetails(),
      DateTimeSelector(),
      PaymentPage(),
    ];
  }

  void nextPage() {
    if (index < screens().length - 1) {
      setState(() {
        index++;
      });
      _scrollToTop();
    } else {
      // Handle the finish action here, e.g., navigate to a confirmation page
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
                imageUrl: widget.imageUrl,
                name: widget.name,
                job: widget.job,
                location: widget.location,
                distance: widget.distance,
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
