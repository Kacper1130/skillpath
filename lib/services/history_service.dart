// History Service - manages lesson completion history and quiz attempts
import 'package:hive_flutter/hive_flutter.dart';
import '../models/lesson.dart';

class HistoryService {
  static const String _progressBoxName = 'progress';
  static const String _completedLessonsKey = 'completedLessons';

  Future<void> initialize() async {
    await Hive.openBox<Map>(_progressBoxName);
  }

  Future<void> markLessonCompleted(Lesson lesson) async {
    final box = Hive.box<Map>(_progressBoxName);
    final completedLessons = await getCompletedLessons();
    
    if (!completedLessons.contains(lesson.id)) {
      completedLessons.add(lesson.id);
      await box.put(_completedLessonsKey, {'lessons': completedLessons});
    }
  }

  Future<List<String>> getCompletedLessons() async {
    final box = Hive.box<Map>(_progressBoxName);
    final data = box.get(_completedLessonsKey);
    if (data != null && data['lessons'] != null) {
      return List<String>.from(data['lessons']);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getProgressForLesson(String lessonId) async {
    final box = Hive.box<Map>(_progressBoxName);
    final progress = box.get(lessonId);
    if (progress != null && progress['attempts'] != null) {
      return List<Map<String, dynamic>>.from(progress['attempts']);
    }
    return [];
  }

  Future<void> updateQuizScore(Lesson lesson, int score) async {
    final box = Hive.box<Map>(_progressBoxName);
    final attempts = await getProgressForLesson(lesson.id);
    
    attempts.add({
      'score': score,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await box.put(lesson.id, {
      'attempts': attempts,
      'lastAttempt': DateTime.now().toIso8601String(),
      'bestScore': attempts.map((a) => a['score'] as int).reduce((a, b) => a > b ? a : b),
    });
  }

  Future<Map<String, dynamic>> getLessonStats(String lessonId) async {
    final attempts = await getProgressForLesson(lessonId);
    if (attempts.isEmpty) {
      return {
        'bestScore': 0,
        'averageScore': 0,
        'attemptsCount': 0,
        'lastAttempt': null,
      };
    }

    final scores = attempts.map((a) => a['score'] as int).toList();
    return {
      'bestScore': scores.reduce((a, b) => a > b ? a : b),
      'averageScore': (scores.reduce((a, b) => a + b) / scores.length).round(),
      'attemptsCount': scores.length,
      'lastAttempt': attempts.last['timestamp'],
    };
  }
} 