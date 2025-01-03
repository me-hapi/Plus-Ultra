import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingap/features/journaling/logic/create_logic.dart';
import 'package:lingap/features/journaling/ui/journal_widgets/journal_card.dart';

class JournalCollection extends StatefulWidget {
  final List<Map<String, dynamic>> dates;

  const JournalCollection({
    Key? key,
    required this.dates,
  }) : super(key: key);

  @override
  _JournalCollectionState createState() => _JournalCollectionState();
}

class _JournalCollectionState extends State<JournalCollection> {
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Journal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Import the intl package for date formatting

// Weekday Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.dates.asMap().entries.map((entry) {
                  final index = entry.key;
                  final date = entry.value;

                  final isSelected = date['selected'] == true;

                  // Parse and format the date
                  // final DateTime parsedDate = DateTime.parse(date[
                  //     'date']); // Ensure date['date'] is a valid ISO 8601 string
                  final DateTime parsedDate = date['date'];
                  final String day = DateFormat('EEE')
                      .format(parsedDate); // Short day, e.g., Mon, Tue
                  final String dayNumber = DateFormat('d')
                      .format(parsedDate); // Day number, e.g., 25, 26

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Update the selected state for all dates
                        for (var d in widget.dates) {
                          d['selected'] = false;
                        }
                        date['selected'] = true;
                      });

                      scrollController.animateTo(
                        index *
                            200.0, // Approximate height of each journal card
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape
                            .rectangle, // Maintain rectangle with rounded corners
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? Colors.grey : Colors.transparent,
                          width: isSelected ? 4 : 2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            day, // Display the short day
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dayNumber, // Display the date number
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: isSelected ? Colors.green : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Timeline Section
            Row(
              children: const [
                Text(
                  'Timeline',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.dates.length,
                itemBuilder: (context, index) {
                  final date = widget.dates[index];

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            if (index == 0 &&
                                widget.dates[index]['emotion'] != 'None')
                              const SizedBox(height: 80), // Initial spacing
                            if (index > 0 &&
                                widget.dates[index]['emotion'] != 'None')
                              Container(
                                width: 2,
                                height: 80,
                                color: Colors
                                    .grey[300], // Connector line between cards
                              ),
                            if (widget.dates[index]['emotion'] !=
                                'None') // Check if 'time' is not null
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.white,
                                elevation: 0,
                                child: Container(
                                  width: 60,
                                  height: 80,
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.dates[index]['time'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (index < widget.dates.length - 1 &&
                                widget.dates[index]['emotion'] != 'None')
                              Container(
                                width: 2,
                                height: 70,
                                color:
                                    Colors.grey[300], // Bottom connector line
                              ),
                          ],
                        ),
                      ),

                      // Right Column
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: widget.dates[index]['time'] !=
                                  null // Conditional check
                              ? JournalCard(
                                  emotion: date['emotion'],
                                  title: date['title'],
                                  date: date['date'].toString(),
                                  time: date['time'].toString(),
                                  journalItems: date['content'],
                                )
                              : const SizedBox(), // Placeholder when condition is false
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
