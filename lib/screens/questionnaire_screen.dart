// screens/questionnaire_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../question_bank.dart';
import 'summary_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int currentQuestion = 0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<StudentProvider>(context, listen: false);
    provider.loadResponses();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final question = questions[currentQuestion];
    final selectedOption = provider.questionnaireResponses[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text("Personality Questionnaire"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Question ${currentQuestion + 1} / ${questions.length}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(question.text, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),

            ...List.generate(question.options.length, (index) {
              return CheckboxListTile(
                title: Text(question.options[index]),
                value: selectedOption == index,
                onChanged: (val) async {
                  if (val == true) {
                    await provider.saveResponse(currentQuestion, index);
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),

            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestion > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentQuestion--;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text("Previous"),
                  ),
                ElevatedButton(
                  onPressed:
                      selectedOption == null
                          ? null
                          : () {
                            if (currentQuestion < questions.length - 1) {
                              setState(() {
                                currentQuestion++;
                              });
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SummaryScreen(),
                                ),
                              );
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text(
                    currentQuestion == questions.length - 1 ? "Submit" : "Next",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
