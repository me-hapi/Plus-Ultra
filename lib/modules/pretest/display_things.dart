import 'package:flutter/material.dart';

class DisplayThings extends StatefulWidget {
  final Function(List<String>) onThingsUpdated; // Callback to pass the updated list to the parent

  const DisplayThings({Key? key, required this.onThingsUpdated}) : super(key: key);

  @override
  _DisplayThingsState createState() => _DisplayThingsState();
}

class _DisplayThingsState extends State<DisplayThings> {
  final TextEditingController _controller = TextEditingController();
  List<String> thingsList = []; // List to store the things that make the user happy

  // Add item to the list
  void addItem() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        thingsList.add(_controller.text);
        widget.onThingsUpdated(thingsList); // Notify parent widget
        _controller.clear(); // Clear the input field
      }
    });
  }

  // Remove item from the list
  void removeItem(String item) {
    setState(() {
      thingsList.remove(item);
      widget.onThingsUpdated(thingsList); // Notify parent widget
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input field
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'What makes you happy?',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),

        // Button to add item
        ElevatedButton(
          onPressed: addItem,
          child: Text('Add'),
        ),
        SizedBox(height: 20),

        // Word cloud for happy things
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: thingsList.map((thing) {
            return GestureDetector(
              onTap: () => removeItem(thing),
              child: Chip(
                label: Text(thing),
                backgroundColor: Colors.green[300],
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
