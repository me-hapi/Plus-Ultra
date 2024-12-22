import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/modules/profile/ui/profile_page.dart';

class GreetingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => ProfilePage()));

                    context.push('/profile');
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.person, size: 24, color: Colors.white),
                    backgroundColor: Colors.grey,
                    radius: 20,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    //NOTIFICATION FUNCTION
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Hello, Shinomiya',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                color: Color(0xFF473c38),
              ),
            ),
            Text(
              'How are you today?',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: Color(0xFF473c38),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEmojiButton('Cheerful', 'assets/mood/cheerful.png'),
                _buildEmojiButton('Happy', 'assets/mood/happy.png'),
                _buildEmojiButton('Neutral', 'assets/mood/neutral.png'),
                _buildEmojiButton('Sad', 'assets/mood/sad.png'),
                _buildEmojiButton('Awful', 'assets/mood/awful.png'),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String label, String assetPath) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Handle emoji button click
            print('$label clicked');
          },
          child: Image.asset(
            assetPath,
            height: 40, // Adjust icon size
            width: 40,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
