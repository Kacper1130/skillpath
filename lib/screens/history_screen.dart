// History Screen - displays the history of completed lessons and quiz attempts
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import for Timestamp
import '../services/history_service.dart';
import '../services/lesson_service.dart'; // To get lesson titles
import '../widgets/unified_app_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  final LessonService _lessonService = LessonService();
  Future<List<Map<String, dynamic>>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = _fetchEnrichedHistory();
    });
  }

  Future<List<Map<String, dynamic>>> _fetchEnrichedHistory() async {
    final history = await _historyService.getFullHistory();
    final lessons = await _lessonService.getAllLessons();
    final lessonMap = {for (var lesson in lessons) lesson.id: lesson};

    return history.map((attempt) {
      return {
        ...attempt,
        'lessonTitle': lessonMap[attempt['lessonId']]?.title ?? 'Unknown Lesson',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const UnifiedAppBar(title: 'History'),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.3),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => _loadHistory(),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No history found.'));
                }

                final history = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final timestamp = (item['timestamp'] as Timestamp?)?.toDate();
                    final formattedDate = timestamp != null
                        ? DateFormat.yMMMd().add_jm().format(timestamp)
                        : 'No date';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(item['lessonTitle']),
                        subtitle: Text('Score: ${item['score']}/${item['totalQuestions']}\n$formattedDate'),
                        trailing: Text(
                          '${item['percentage']}%',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _getScoreColor(item['percentage']),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
} 