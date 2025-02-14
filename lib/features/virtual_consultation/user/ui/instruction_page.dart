import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InstructionsPage extends StatelessWidget {
  final String roomId;
  final String name;
  final int appointmentId;
  const InstructionsPage(
      {super.key,
      required this.roomId,
      required this.name,
      required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mindfulBrown['Brown10'],
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Image.asset('assets/consultation/steth.png',
                  width: 400), // Update with actual image path
              SizedBox(height: 20),
              Text(
                'Psst...Before your consultation..',
                style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Please ensure the following:',
                style: TextStyle(color: optimisticGray['Gray50'], fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildInstructionCard('Stable connection', LucideIcons.wifi,
                  empathyOrange['Orange50']!),
              _buildInstructionCard('Well-lit space', LucideIcons.lightbulb,
                  serenityGreen['Green50']!),
              _buildInstructionCard('Quiet place', LucideIcons.volume2,
                  reflectiveBlue['Blue50']!),

              SizedBox(height: 50),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/consultation-room', extra: {
                      'roomId': roomId,
                      'name': name,
                      'appointmentId': appointmentId
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mindfulBrown['Brown80'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'I understand',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildInstructionCard(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(color: mindfulBrown['Brown80'], fontSize: 16),
            ),
            Icon(icon, color: color, size: 24),
          ],
        ),
      ),
    );
  }
}
