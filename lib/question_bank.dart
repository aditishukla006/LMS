// question_bank.dart
class Question {
  final String text;
  final List<String> options;

  Question(this.text, this.options);
}

final List<Question> questions = List.generate(
  35,
  (index) => Question("Sample Question ${index + 1}?", [
    "Option A",
    "Option B",
    "Option C",
    "Option D",
  ]),
);
