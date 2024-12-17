import 'package:flutter/material.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/verification_page.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  int currentIndex = 0;

  final List<String> steps = [
    'Verification',
    'Information',
    'Payment',
    'Clinic',
    'Availability',
  ];

  List<Widget> screens() {
    return [
      VerificationPage(),
      _buildStepContent('Information Screen Content'),
      _buildStepContent('Payment Screen Content'),
      _buildStepContent('Clinic Screen Content'),
      _buildStepContent('Availability Screen Content'),
    ];
  }

  Widget _buildStepContent(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void nextPage() {
    if (currentIndex < steps.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have completed all steps!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Application Process",
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Steps with dots and connector lines
          LayoutBuilder(
            builder: (context, constraints) {
              final double totalWidth =
                  constraints.maxWidth - 40; // Total width with padding
              final double stepWidth = totalWidth / ((steps.length - 1) * 2);

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(steps.length, (index) {
                  return Row(
                    children: [
                      _buildStep(isActive: index <= currentIndex),
                      if (index < steps.length - 1)
                        _buildConnectorLine(
                          stepWidth: stepWidth,
                          isPreviousActive: index <=
                              currentIndex, // Colors first half of the line
                          isCurrentActive: index + 1 <=
                              currentIndex, // Colors second half of the line
                        ),
                    ],
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: steps.map((step) {
              int stepIndex = steps.indexOf(step);
              return SizedBox(
                width: 68,
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: stepIndex == currentIndex
                        ? Colors.blueGrey
                        : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: screens()[currentIndex],
          ),
          GestureDetector(
            onTap: nextPage,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: Text(
                currentIndex < steps.length - 1 ? 'Continue' : 'Finish',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
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

  Widget _buildConnectorLine({
    required double stepWidth,
    required bool isPreviousActive,
    required bool isCurrentActive,
  }) {
    return Row(
      children: [
        // First half of the line: Depends on the previous dot being active
        Container(
          width: stepWidth / 2,
          height: 2,
          color: isPreviousActive ? Colors.blueGrey : Colors.grey,
        ),
        // Second half of the line: Depends on the current dot being active
        Container(
          width: stepWidth / 2,
          height: 2,
          color: isCurrentActive ? Colors.blueGrey : Colors.grey,
        ),
      ],
    );
  }
}
