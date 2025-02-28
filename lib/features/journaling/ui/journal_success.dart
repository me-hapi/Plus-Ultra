import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';

class JournalSuccessPage extends StatefulWidget {
  final int id;
  final String emotion;
  final String date;
  final String time;
  final String title;
  final List<JournalItem> journalItems;

  const JournalSuccessPage(
      {Key? key,
      required this.id,
      required this.emotion,
      required this.date,
      required this.time,
      required this.title,
      required this.journalItems})
      : super(key: key);

  @override
  State<JournalSuccessPage> createState() => _JournalSuccessPageState();
}

class _JournalSuccessPageState extends State<JournalSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/journal/created.png',
              height: 370,
              width: 370,
            ),
            const SizedBox(height: 20),
            Text(
              'Journal Created!',
              style: TextStyle(
                color: mindfulBrown['Brown80'],
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Congratulations, you've created a journal entry for today!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/bottom-nav', extra: 2);
                  Future.microtask(() {
                    context.push('/journal-details', extra: {
                      'id': widget.id,
                      'emotion': widget.emotion,
                      'date': DateTime.now().toString(),
                      'time': DateTime.now()
                          .toLocal()
                          .toIso8601String()
                          .split('T')[1]
                          .substring(0, 5),
                      'title': widget.title,
                      'journalItems': widget.journalItems
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mindfulBrown['Brown80'],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
