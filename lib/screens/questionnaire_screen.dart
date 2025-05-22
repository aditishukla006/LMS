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

    final List<Question> limitedQuestions = questions.take(8).toList();
    final totalQuestions = limitedQuestions.length;

    final questionIndex = currentQuestion;
    final question = limitedQuestions[questionIndex];
    final selectedOption = provider.questionnaireResponses[questionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Personality Questionnaire"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestion + 1} of $totalQuestions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            LinearProgressIndicator(
              value: (currentQuestion + 1) / totalQuestions,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),

            SizedBox(height: 30),

            Text(
              question.text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),

            ...List.generate(question.options.length, (index) {
              return CheckboxListTile(
                title: Text(question.options[index]),
                value: selectedOption == index,
                onChanged: (val) async {
                  if (val == true) {
                    await provider.saveResponse(questionIndex, index);
                  }
                  setState(() {});
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),

            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestion > 0)
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentQuestion--;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 25),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text("Previous"),
                    ),
                  ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        selectedOption == null
                            ? null
                            : () {
                              if (currentQuestion < totalQuestions - 1) {
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
                      textStyle: TextStyle(fontSize: 25),
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      currentQuestion == totalQuestions - 1 ? "Submit" : "Next",
                    ),
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
