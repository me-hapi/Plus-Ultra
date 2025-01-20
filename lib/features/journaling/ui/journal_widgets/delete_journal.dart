import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class DeleteJournalDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                'assets/journal/delete.png', // Replace with your asset image path
                height: 220.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Delete Journal?',
              style: TextStyle(
                color: mindfulBrown['Brown80'],
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Are you sure to delete your journal?\nThis operation can't be undone",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: optimisticGray['Gray60'],
              ),
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: presentRed['Red10'],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No, Don't Delete",
                          style: TextStyle(
                              fontSize: 14, color: presentRed['Red40']),
                        ),
                        SizedBox(
                          height: 20,
                          child: Image.asset('assets/journal/cancel.png'),
                        )
                      ],
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: presentRed['Red40'],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Yes, Delete",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(
                          height: 20,
                          child: Image.asset('assets/journal/trash.png'),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showDeleteJournalDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => DeleteJournalDialog(),
  );
}
