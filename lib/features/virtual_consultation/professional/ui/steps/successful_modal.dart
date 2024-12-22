import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/modules/profile/ui/profile_page.dart';

class SuccessfulModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pop(), // Close popup when background is tapped
      child: Container(
        child: Center(
          child: Container(
            width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // Popup content background color
              borderRadius: BorderRadius.circular(16),
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
                    'assets/test.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                // Text button
                TextButton(
                  onPressed: () {
                    context
                        .go('/bottom-nav'); // Clears the stack and navigates to Home
                    Future.microtask(() {
                      context.push('/profile'); // Adds Profile on top of Home
                    });
                  },
                  child: Text(
                    'Great!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
