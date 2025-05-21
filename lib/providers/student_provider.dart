// providers/student_provider.dart
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Assignment {
  final String subject;
  final String title;
  final String dueDate; // You can change this to DateTime if you want
  final String status; // "On Time", "Approaching", "Late"

  Assignment({
    required this.subject,
    required this.title,
    required this.dueDate,
    required this.status,
  });
}

class StudentProvider extends ChangeNotifier {
  String name = "Aditi Shukla";
  String studentClass = "10th Grade";
  String profilePicUrl = "https://i.pravatar.cc/150?img=3";

  // Progress data (dummy)
  Map<String, double> assignmentProgress = {
    "Math": 0.75,
    "Science": 0.5,
    "English": 0.9,
  };

  Map<String, int> weeklyAssignments = {
    "Mon": 2,
    "Tue": 1,
    "Wed": 3,
    "Thu": 5,
    "Fri": 1,
    "Sat": 0,
    "Sun": 2,
  };

  // Questionnaire responses saved locally
  Map<int, int> questionnaireResponses = {};

  // Upcoming assignments list
  List<Assignment> upcomingAssignments = [
    Assignment(
      subject: "Math",
      title: "Algebra Worksheet",
      dueDate: "May 21, 2025",
      status: "On Time",
    ),
    Assignment(
      subject: "Math",
      title: "Geometry Problems",
      dueDate: "May 23, 2025",
      status: "On Time",
    ),
  ];

  // Submission status counts
  Map<String, double> submissionStatus = {
    "On Time": 3,
    "Approaching": 1,
    "Late": 2,
  };

  bool isDarkMode = false;

  void toggleTheme(bool value) async {
    isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }

  bool _responsesLoaded = false;

  // Load saved responses
  Future<void> loadResponses() async {
    if (_responsesLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 8; i++) {
      questionnaireResponses[i] = prefs.getInt('q_$i')!;
    }
    _responsesLoaded = true;
    notifyListeners();
  }

  // Save a response

  Future<void> saveResponse(int questionIndex, int answerIndex) async {
    questionnaireResponses[questionIndex] = answerIndex;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('question_$questionIndex', answerIndex);
    notifyListeners();
  }

  // Clear all saved questionnaire responses
  void clearResponses() {
    questionnaireResponses = List.filled(8, null) as Map<int, int>;
    _responsesLoaded = false;
    notifyListeners();
  }
}
