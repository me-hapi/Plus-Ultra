// application_page.dart
import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/professional/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/professional/logic/application_logic.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/steps/availability_page.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/steps/clinic_page.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/steps/information_page.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/steps/payment_page.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/steps/verification_page.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  final SupabaseDB supabaseDB = SupabaseDB(client);
  final Map<String, dynamic> stepData = {
    'verification': {},
    'information': {},
    'payment': {},
    'clinic': {},
    'availability': {},
  };

  final List<String> steps = [
    'Verification',
    'Information',
    'Payment',
    'Clinic',
    'Availability',
  ];

  late ApplicationLogic appLogic;

  @override
  void initState() {
    super.initState();
    appLogic = ApplicationLogic(
      context: context,
      supabaseDB: supabaseDB,
      stepData: stepData,
      steps: steps,
    );
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                        _buildStep(isActive: index <= appLogic.currentIndex),
                        if (index < steps.length - 1)
                          _buildConnectorLine(
                            stepWidth: stepWidth,
                            isPreviousActive: index <= appLogic.currentIndex,
                            isCurrentActive: index + 1 <= appLogic.currentIndex,
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
                      color: stepIndex == appLogic.currentIndex
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
            SizedBox(
              child: getScreen(appLogic.currentIndex),
            ),
            GestureDetector(
              onTap: () async {
                await appLogic.nextPage();
                setState(() {});
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20, top: 20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Text(
                  appLogic.currentIndex < steps.length - 1 ? 'Continue' : 'Finish',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getScreen(int index) {
    final screens = [
      VerificationPage(
        onDataChanged: (data) => stepData['verification'] = data,
      ),
      InformationPage(
        onDataChanged: (data) => stepData['information'] = data,
      ),
      PaymentPage(
        onDataChanged: (data) => stepData['payment'] = data,
      ),
      ClinicPage(
        onDataChanged: (data) => stepData['clinic'] = data,
      ),
      AvailabilityPage(
        onDataChanged: (data) => stepData['availability'] = data,
      ),
    ];
    return screens[index];
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
        Container(
          width: stepWidth / 2,
          height: 2,
          color: isPreviousActive ? Colors.blueGrey : Colors.grey,
        ),
        Container(
          width: stepWidth / 2,
          height: 2,
          color: isCurrentActive ? Colors.blueGrey : Colors.grey,
        ),
      ],
    );
  }
}
