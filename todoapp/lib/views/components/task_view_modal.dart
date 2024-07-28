import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/utils/theme/app_pallete.dart';

class TaskViewModal extends StatelessWidget {
  final Map task;

  TaskViewModal({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                "Task Details",
                style: GoogleFonts.poppins(
                  color: AppPallete.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text('Title'),
              subtitle: Text(task['title'] ?? 'No Title'),
            ),
            ListTile(
              title: Text('Description'),
              subtitle: Text(task['description'] ?? 'No Description'),
            ),
            ListTile(
              title: Text('Completed'),
              subtitle: Text(task['completed'] ? 'Yes' : 'No'),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppPallete.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    color: AppPallete.surfaceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
