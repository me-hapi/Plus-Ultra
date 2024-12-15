import 'package:flutter/material.dart';
import 'package:lingap/features/virtual_consultation/user/ui/booking_page.dart';

class ProfilePage extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String job;
  final String location;
  final String distance;

  const ProfilePage({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.job,
    required this.location,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on,
                                      size: 18.0, color: Colors.grey[600]),
                                  SizedBox(width: 4.0),
                                  Text(
                                    location,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    distance,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
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
                            '₱ 500',
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
                            '25',
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
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin id arcu aliquet, elementum nisi quis, condimentum nibh.', // Placeholder for bio
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
                                imageUrl: imageUrl,
                                name: name,
                                job: job,
                                location: location,
                                distance: distance)),
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
