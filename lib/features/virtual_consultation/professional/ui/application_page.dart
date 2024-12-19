import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/professional/data/supabase_db.dart';
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
  int currentIndex = 0;
  SupabaseDB supabaseDB = SupabaseDB(client);

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

  List<Widget> screens() {
    return [
      VerificationPage(
        onDataChanged: (data) {
          stepData['verification'] = data;
        },
      ),
      InformationPage(
        onDataChanged: (data) {
          stepData['information'] = data;
        },
      ),
      PaymentPage(
        onDataChanged: (data) {
          stepData['payment'] = data;
        },
      ),
      ClinicPage(
        onDataChanged: (data) {
          stepData['clinic'] = data;
        },
      ),
      AvailabilityPage(
        onDataChanged: (data) {
          stepData['availability'] = data;
        },
      ),
    ];
  }

  Future<void> nextPage() async {
    // Validation check for the 'Verification' step
    if (currentIndex == 0) {
      final verificationData = stepData['verification'];
      if (verificationData == null ||
          verificationData['frontImage'] == null ||
          verificationData['backImage'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Please upload both front and back ID images to continue.")),
        );
        return; // Stop the navigation
      }
    }

    // Validation check for the 'Information' step
    if (currentIndex == 1) {
      final informationData = stepData['information'];
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please fill out all fields to continue.")),
        );
        return; // Stop the navigation
      }

      // Additional validation for mobile and email
      if (!RegExp(r'^[0-9]+$').hasMatch(informationData['mobile'])) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid mobile number.")),
        );
        return; // Stop the navigation
      }

      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(informationData['email'])) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid email address.")),
        );
        return; // Stop the navigation
      }
    }

    // Validation check for the 'Payment' step
    if (currentIndex == 2) {
      final paymentData = stepData['payment'];
      if (paymentData == null || paymentData['isFreeConsultation'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please select if consultation is free or paid.")),
        );
        return; // Stop the navigation
      }

      if (paymentData['isFreeConsultation'] == false) {
        if (paymentData['consultationFee'] == null ||
            paymentData['consultationFee'].isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a consultation fee.")),
          );
          return; // Stop the navigation
        }

        // if (paymentData['gcashQrImage'] == null) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("Please upload a GCash QR code.")),
        //   );
        //   return; // Stop the navigation
        // }
      }
    }

    // Validation check for the 'Clinic' step
    if (currentIndex == 3) {
      final clinicData = stepData['clinic'];
      if (clinicData == null || clinicData['teleconsultationOnly'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please specify if teleconsultation only or not.")),
        );
        return; // Stop the navigation
      }

      if (clinicData['teleconsultationOnly'] == false) {
        if (clinicData['clinicName'] == null ||
            clinicData['clinicName'].isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter the clinic name.")),
          );
          return; // Stop the navigation
        }

        if (clinicData['clinicAddress'] == null ||
            clinicData['clinicAddress'].isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter the clinic address.")),
          );
          return; // Stop the navigation
        }

        if (clinicData['selectedLocation'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a clinic location.")),
          );
          return; // Stop the navigation
        }
      }
    }

    // Validation check for the 'Availability' step
    if (currentIndex == 4) {
      final availabilityData = stepData['availability'];
      if (availabilityData == null ||
          availabilityData['consultationFrequency'] == null ||
          availabilityData['availableDays'] == null ||
          availabilityData['availableDays'].isEmpty ||
          availabilityData['startTime'] == null ||
          availabilityData['endTime'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Please provide all required availability details.")),
        );
        return; // Stop the navigation
      }

      if (availabilityData['startTime']
              .compareTo(availabilityData['endTime']) >=
          0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Start time must be before end time.")),
        );
        return; // Stop the navigation
      }
    }

    // Move to the next step or process completion
    if (currentIndex < steps.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Final processing
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
                        _buildStep(isActive: index <= currentIndex),
                        if (index < steps.length - 1)
                          _buildConnectorLine(
                            stepWidth: stepWidth,
                            isPreviousActive: index <= currentIndex,
                            isCurrentActive: index + 1 <= currentIndex,
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
            // Dynamically adjust the content height
            SizedBox(
              child: screens()[currentIndex],
            ),
            GestureDetector(
              onTap: nextPage,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20, top: 20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Text(
                  currentIndex < steps.length - 1 ? 'Continue' : 'Finish',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
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
