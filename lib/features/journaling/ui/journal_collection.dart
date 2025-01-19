import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingap/core/const/colors.dart';
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
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Text(
                'My Journals',
                style: TextStyle(
                    color: mindfulBrown['Brown80']!,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.dates.asMap().entries.map((entry) {
              final index = entry.key;
              final date = entry.value;

              final isSelected = date['selected'] == true;

              final DateTime parsedDate = date['date'];
              final String day = DateFormat('EEE')
                  .format(parsedDate); // Short day, e.g., Mon, Tue
              final String dayNumber = DateFormat('d')
                  .format(parsedDate); // Day number, e.g., 25, 26

              return GestureDetector(
                  onTap: () {
                    if (date['emotion'] != 'None') {
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
                    }
                  },
                  child: SizedBox(
                    width: isSelected ? 65 : 63,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape
                            .rectangle, // Maintain rectangle with rounded corners
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? serenityGreen['Green50']!
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            day, // Display the short day
                            style: TextStyle(
                              color: isSelected
                                  ? mindfulBrown['Brown80']
                                  : optimisticGray['Gray40'],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            dayNumber, // Display the date number
                            style: TextStyle(
                              color: isSelected
                                  ? mindfulBrown['Brown80']
                                  : optimisticGray['Gray60'],
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: isSelected
                                ? serenityGreen['Green50']
                                : (date['emotion'] == 'None')
                                    ? Colors.transparent
                                    : optimisticGray['Gray30'],
                          ),
                        ],
                      ),
                    ),
                  ));
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Timeline Section
          Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Text(
                'Timeline',
                style: TextStyle(
                    color: mindfulBrown['Brown80']!,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.dates
                  .where((date) => date['emotion'] != 'None')
                  .length,
              itemBuilder: (context, index) {
                // Filtered list
                final filteredDates = widget.dates
                    .where((date) => date['emotion'] != 'None')
                    .toList();
                final date = filteredDates[index];

                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              if (index == 0)
                                const SizedBox(height: 60), // Initial spacing
                              if (index > 0)
                                Container(
                                  width: 4,
                                  height: 60,
                                  color: mindfulBrown['Brown30'],
                                ),
                              if (date['emotion'] != 'None')
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: Colors.white,
                                  elevation: 0,
                                  child: Container(
                                    width: 65,
                                    height: 65,
                                    padding: const EdgeInsets.all(8),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          child: Image.asset(
                                              'assets/journal/time.png'),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          date['time'] ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: mindfulBrown['Brown80']!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (index < filteredDates.length - 1)
                                Container(
                                  width: 4,
                                  height: 60,
                                  color: mindfulBrown['Brown30'],
                                ),
                            ],
                          ),
                        ),

                        // Right Column
                        Expanded(
                          flex: 3,
                          child: JournalCard(
                            emotion: date['emotion'],
                            title: date['title'],
                            date: date['date'].toString(),
                            time: date['time'].toString(),
                            journalItems: date['content'],
                          ),
                        ),
                      ],
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
