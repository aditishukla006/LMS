import 'package:flutter/material.dart';
import 'package:lms_project/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import 'questionnaire_screen.dart';
import 'progress_screen.dart';
import 'quiz_screen.dart';
import 'feedback_screen.dart';

import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${provider.name}"),
        actions: [
          Builder(
            builder:
                (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(provider.profilePicUrl),
                  ),
                ),
          ),
          SizedBox(width: 12),
        ],
      ),
      endDrawer: _buildProfileDrawer(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Info Card
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(provider.profilePicUrl),
                  radius: 30,
                ),
                title: Text(provider.name, style: TextStyle(fontSize: 20)),
                subtitle: Text(provider.studentClass),
              ),
            ),

            SizedBox(height: 20),

            // Key Features cards
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildFeatureCard(context, "Start Learning", Icons.school, () {
                  // TODO: Navigate to Learning screen
                }),
                _buildFeatureCard(context, "Continue Quiz", Icons.quiz, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QuizScreen()),
                  );
                }),
                _buildFeatureCard(
                  context,
                  "Submit Feedback",
                  Icons.feedback,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FeedbackScreen()),
                    );
                  },
                ),
                _buildFeatureCard(context, "My Progress", Icons.bar_chart, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProgressScreen()),
                  );
                }),
                _buildFeatureCard(
                  context,
                  "Personality Questionnaire",
                  Icons.assignment,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QuestionnaireScreen()),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 30),

            // Progress Chart - Assignments progress (Pie Chart)
            _buildAssignmentProgressChart(provider),

            SizedBox(height: 30),

            // Weekly assignments bar chart
            _buildWeeklyAssignmentsChart(provider),

            SizedBox(height: 30),

            // --- NEW SECTION: Submission Status Pie Chart ---
            //_buildSubmissionStatusChart(provider.submissionStatus),
            SizedBox(height: 30),

            // --- NEW SECTION: Upcoming Assignments grouped by Subject ---
            _buildUpcomingAssignments(provider.upcomingAssignments),

            SizedBox(height: 30),

            // 45-minute daily study plan card
            _buildStudyPlanCard(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 24,
      height: 150, // fixed height for better alignment
      child: Card(
        color: isDark ? Colors.grey[800] : Colors.blue.shade100,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // vertical center
              crossAxisAlignment:
                  CrossAxisAlignment.center, // horizontal center
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentProgressChart(StudentProvider provider) {
    List<PieChartSectionData> sections = [];
    provider.assignmentProgress.forEach((subject, progress) {
      sections.add(
        PieChartSectionData(
          value: progress,
          title: "${(progress * 100).toInt()}%",
          color: Colors.primaries[sections.length % Colors.primaries.length],
          radius: 50,
          titleStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Assignments Progress",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDrawer(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(provider.name),
            accountEmail: Text(provider.studentClass),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(provider.profilePicUrl),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () {
              // TODO: Navigate to Edit Profile Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          SwitchListTile(
            title: Text("Dark Mode"),
            secondary: Icon(Icons.brightness_6),
            value: provider.isDarkMode,
            onChanged: (val) {
              provider.toggleTheme(val); // Implement in provider
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyAssignmentsChart(StudentProvider provider) {
    List<BarChartGroupData> barGroups = [];

    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    for (int i = 0; i < days.length; i++) {
      int count = provider.weeklyAssignments[days[i]] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color:
                  count == 0
                      ? Colors.green
                      : (count <= 2 ? Colors.orange : Colors.red),
              width: 20,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upcoming Assignments This Week",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 5,
              barGroups: barGroups,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String day = days[value.toInt()];
                      return Text(day);
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // NEW: Upcoming Assignments grouped by Subject
  Widget _buildUpcomingAssignments(List<Assignment> assignments) {
    if (assignments.isEmpty) {
      return SizedBox();
    }

    // Group by subject
    Map<String, List<Assignment>> grouped = {};
    for (var assignment in assignments) {
      grouped.putIfAbsent(assignment.subject, () => []);
      grouped[assignment.subject]!.add(assignment);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upcoming Assignments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ...grouped.entries.map(
          (entry) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              ...entry.value.map(
                (assignment) => Card(
                  child: ListTile(
                    title: Text(assignment.title),
                    subtitle: Text("Due: ${assignment.dueDate}"),
                  ),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudyPlanCard(BuildContext context, StudentProvider provider) {
    final theme = Theme.of(context);
    // Add `BuildContext` if needed
    final isDark = theme.brightness == Brightness.dark;

    List<String> sessions = [
      "15 min: Review last class notes",
      "15 min: Practice exercises",
      "15 min: Quiz or flashcards",
    ];

    return Card(
      color: isDark ? Colors.teal.shade900 : Colors.teal.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daily 45-minute Study Plan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 12),
            ...sessions.map(
              (s) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  s,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color,
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
