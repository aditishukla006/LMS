// screens/summary_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Questionnaire Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children:
              provider.questionnaireResponses.entries.map((entry) {
                return ListTile(
                  title: Text("Question ${entry.key + 1}"),
                  subtitle: Text(
                    "Answer: Option ${String.fromCharCode(65 + entry.value)}",
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
