import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/virtual_consultation/user/ui/booking_page.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> professionalData;

  const ProfilePage({
    Key? key,
    required this.professionalData,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final String imageUrl = widget.professionalData['imageUrl'] ?? '';
    final String name = widget.professionalData['name'] ?? '';
    final String job = widget.professionalData['job'] ?? '';
    final String location = widget.professionalData['location'] ?? '';
    final String distance = widget.professionalData['distance'] ?? '';
    final sessionFee = widget.professionalData['professional_payment']
            ['consultation_fee'] ??
        'Free';
    final String completedSessions =
        widget.professionalData['completedSessions'] ?? '25';
    final String personalBio = widget.professionalData['bio'] ??
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin id arcu aliquet, elementum nisi quis, condimentum nibh.';
    final String? clinicName =
        widget.professionalData['professional_clinic']['clinic_name'];

    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top image covering full width
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip
                      .none, // Ensures content extending outside Stack is visible
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Container(
                          width: screenWidth,
                          height: screenWidth,
                          child: Image.asset('assets/doctor.jpg')
                          // Image.network(
                          //   imageUrl,
                          //   fit: BoxFit.cover,
                          //   errorBuilder: (context, error, StackTrace) {
                          //     return const Icon(Icons.person, size: 50);
                          //   },
                          // ),
                          ),
                    ),
                    // Positioned Card
                    Positioned(
                      bottom:
                          -screenWidth * 0.12, // Position card below the image
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Container(
                          width: screenWidth * 0.8, // Adjust card width
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Adjust to fit content
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: mindfulBrown['Brown80']),
                              ),
                              Text(
                                job,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: mindfulBrown['Brown80']),
                              ),
                              clinicName != null
                                  ? Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: screenWidth * 0.04,
                                            color: mindfulBrown['Brown80']),
                                        const SizedBox(width: 4),
                                        Text(
                                          location,
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.035,
                                              color: mindfulBrown['Brown80']),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          distance,
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.035,
                                              color: mindfulBrown['Brown80']),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'Teleconsultation Only',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //Button
                    Positioned(
                      top: 42,
                      left: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(Icons.arrow_back,
                              color: mindfulBrown['Brown80']),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenWidth * 0.12),
                // Fee and Completed Sessions
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Column(
                          children: [
                            Text(
                              sessionFee.toString(),
                              style: TextStyle(
                                  color: mindfulBrown['Brown80'],
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Session Fee',
                              style: TextStyle(
                                  color: optimisticGray['Gray60'],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        child: VerticalDivider(
                          color: optimisticGray['Gray30'],
                          thickness: 1,
                          width: 1,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Column(
                          children: [
                            Text(
                              completedSessions,
                              style: TextStyle(
                                  color: mindfulBrown['Brown80'],
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Completed Sessions',
                              style: TextStyle(
                                  color: optimisticGray['Gray60'],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // Personal Bio
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Bio',
                        style: TextStyle(
                            color: mindfulBrown['Brown80'],
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        personalBio, // Placeholder for bio
                        style: TextStyle(
                            color: optimisticGray['Gray60'], fontSize: 14.0),
                      ),
                    ],
                  ),
                ),

                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 64.0, vertical: 8.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingPage(
                                  professionalData: widget.professionalData)),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            serenityGreen['Green50'], // Button background color
                        foregroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16),
                        minimumSize: const Size(
                            double.infinity, 52.0), // Set minimum height
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/consultation/schedule.png',
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Set Appointment',
                            style: const TextStyle(
                              fontSize: 18.0, // Set font size
                              fontWeight: FontWeight
                                  .bold, // Optional: Make the text bold
                            ),
                          ),
                        ],
                      )),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Specialty',
                    style: TextStyle(
                        color: mindfulBrown['Brown80'],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Experience & History',
                          style: TextStyle(
                              color: mindfulBrown['Brown80'],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700),
                        ),
                        
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
