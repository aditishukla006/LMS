// screens/progress_screen.dart

// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/student_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final progressData = provider.assignmentProgress;

    return Scaffold(
      appBar: AppBar(title: Text("Your Progress")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Subject-wise Assignment Progress",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            ...progressData.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${entry.key} - ${(entry.value * 100).toInt()}%"),
                  LinearProgressIndicator(
                    value: entry.value,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blue,
                    minHeight: 12,
                  ),
                  SizedBox(height: 16),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
