// TODO Implement this library.
// screens/feedback_screen.dart
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _controller = TextEditingController();
  String _statusMessage = "";

  void _submitFeedback() {
    if (_controller.text.trim().isEmpty) {
      setState(() {
        _statusMessage = "Please enter your feedback.";
      });
      return;
    }

    // You can later store this in Firestore or backend
    setState(() {
      _statusMessage = "Thank you for your feedback!";
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submit Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "We'd love to hear your thoughts!",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Enter your feedback here...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submitFeedback,
              icon: Icon(Icons.send),
              label: Text("Submit"),
            ),
            SizedBox(height: 16),
            Text(
              _statusMessage,
              style: TextStyle(
                color:
                    _statusMessage.contains("Thank")
                        ? Colors.green
                        : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
