import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/modules/profile/ui/profile_page.dart';

class SuccessfulModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/bottom-nav'); // Clears the stack and navigates to Home
        Future.microtask(() {
          context.push('/profile', extra: {
            'bg': bgCons,
            'profile': profileConst
          }); // Adds Profile on top of Home
        });
      }, // Close popup when background is tapped
      child: Container(
        child: Center(
          child: Container(
            width: 400,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // Popup content background color
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/consultation/professional-success.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                // Text button
                Text('Congratulations!',
                    style: TextStyle(
                        fontSize: 24, color: mindfulBrown['Brown80'])),
                SizedBox(height: 8),
                // Text button
                Text(
                    'You are now officially registered as professional in Lingap',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18, color: optimisticGray['Gray50'])),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: mindfulBrown['Brown80'], // Use your brown shade
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: TextButton(
                    onPressed: () {
                      context.go('/bottom-nav');
                      Future.microtask(() {
                        context.push('/profile');
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.zero, // Remove default padding
                    ),
                    child: Text(
                      'Go to Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
