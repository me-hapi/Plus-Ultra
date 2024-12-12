import 'package:flutter/material.dart';

class ExpandableTopNav extends StatefulWidget {
  @override
  _ExpandableTopNavState createState() => _ExpandableTopNavState();
}

class _ExpandableTopNavState extends State<ExpandableTopNav> {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero, // Ensure no padding around the card
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero, // Ensure the card touches the edges
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0), // No rounded corners
        ),
        elevation: 0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: toggleExpanded,
                    child: CircleAvatar(
                      child: Icon(Icons.person, size: 24, color: Colors.white),
                      backgroundColor: Colors.grey,
                      radius: 20,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      // Handle notification icon click
                    },
                  ),
                ],
              ),
              if (isExpanded) ...[
              ]
            ],
          ),
        ),
      ),
    );
  }

}
