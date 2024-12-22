import 'package:flutter/material.dart';
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
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, StackTrace) {
                            return const Icon(Icons.person, size: 50);
                          },
                        ),
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
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Container(
                          width: screenWidth * 0.8, // Adjust card width
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Adjust to fit content
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                job,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                              clinicName != null
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: screenWidth * 0.04,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          location,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          distance,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'Teleconsultation Only',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
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
                              shape: BoxShape.circle, color: Colors.grey[300]),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenWidth * 0.15),
                // Fee and Completed Sessions
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            sessionFee.toString(),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ), // Placeholder for session fee
                          Text(
                            'Session Fee',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            completedSessions,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ), // Placeholder for completed sessions
                          Text(
                            'Completed Sessions',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(thickness: 1.0),

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
                            fontFamily: 'Montserrat',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        personalBio, // Placeholder for bio
                        style:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 14.0),
                      ),
                    ],
                  ),
                ),

                Divider(thickness: 1.0),

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
                      backgroundColor: Colors.grey, // Button background color
                      foregroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      minimumSize: const Size(
                          double.infinity, 52.0), // Set minimum height
                    ),
                    child: Text(
                      'Set Appointment',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16.0, // Set font size
                        fontWeight:
                            FontWeight.bold, // Optional: Make the text bold
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle appointment history
                    },
                    child: Text('Appointment History'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle specialty
                    },
                    child: Text('Specialty'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
