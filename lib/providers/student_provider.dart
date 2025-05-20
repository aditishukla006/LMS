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
  String name = "John Doe";
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

  // Load saved responses
  Future<void> loadResponses() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    questionnaireResponses.clear();
    for (var key in keys) {
      if (key.startsWith('question_')) {
        int qIndex = int.parse(key.split('_')[1]);
        int answer = prefs.getInt(key) ?? -1;
        if (answer != -1) questionnaireResponses[qIndex] = answer;
      }
    }
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
  Future<void> clearResponses() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 35; i++) {
      await prefs.remove('question_$i');
    }
    questionnaireResponses.clear();
    notifyListeners();
  }
}
