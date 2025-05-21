import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../question_bank.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Questionnaire Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children:
              provider.questionnaireResponses.entries
                  .where((entry) => entry.key < questions.length)
                  .map((entry) {
                    final index = entry.key;
                    final selectedIndex = entry.value;
                    final question = questions[index];
                    final selectedAnswer = question.options[selectedIndex];

                    // Extract title (remove text after ":")
                    final questionTitle =
                        question.text.contains(':')
                            ? question.text.split(':').first
                            : question.text;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question ${index + 1}: $questionTitle",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedAnswer,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Divider(height: 24, thickness: 1),
                      ],
                    );
                  })
                  .toList(),
        ),
      ),
    );
  }
}
