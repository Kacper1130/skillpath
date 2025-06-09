// History Screen - displays the history of completed lessons and quiz attempts
import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';
import '../services/history_service.dart';
import 'lesson_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _lessonService = LessonService();
  final _historyService = HistoryService();
  List<Map<String, dynamic>> _lastAttempts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLastAttempts();
  }

  Future<void> _loadLastAttempts() async {
    setState(() => _isLoading = true);
    
    final completedLessons = await _historyService.getCompletedLessons();
    final attempts = <Map<String, dynamic>>[];

    for (final lessonId in completedLessons) {
      final lesson = await _lessonService.getLessonById(lessonId);
      final progress = await _historyService.getProgressForLesson(lessonId);
      
      if (lesson != null && progress.isNotEmpty) {
        // Add all attempts instead of just the last one
        for (final attempt in progress) {
          attempts.add({
            'lesson': lesson,
            'score': attempt['score'],
            'timestamp': attempt['timestamp'],
          });
        }
      }
    }

    // Sort by timestamp (newest first)
    attempts.sort((a, b) {
      final aDate = a['timestamp'] as String;
      final bDate = b['timestamp'] as String;
      return bDate.compareTo(aDate);
    });

    setState(() {
      _lastAttempts = attempts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading lesson history...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
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
        child: _lastAttempts.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No Completed Lessons',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Complete your first lesson to see it here!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _lastAttempts.length,
                itemBuilder: (context, index) {
                  final attempt = _lastAttempts[index];
                  final lesson = attempt['lesson'] as Lesson;
                  final score = attempt['score'] as int;
                  final timestamp = attempt['timestamp'] as String;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LessonScreen(
                              lessonId: lesson.id,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lesson.title,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDate(timestamp),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getScoreColor(score, colorScheme),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$score%',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Color _getScoreColor(int score, ColorScheme colorScheme) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
} 