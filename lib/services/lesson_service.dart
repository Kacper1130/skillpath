import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/lesson.dart';

class LessonService {
  static const String _lessonsPath = 'assets/lessons';
  
  Future<List<Lesson>> getAllLessons() async {
    try {
      // Get all JSON files in the lessons directory
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      
      // Filter for lesson JSON files
      final lessonFiles = manifestMap.keys
          .where((String key) => key.startsWith('$_lessonsPath/') && key.endsWith('.json'))
          .where((String key) => !key.endsWith('lessons.json')) // Exclude the lessons.json file
          .toList();

      // Load and parse each lesson file
      final lessons = <Lesson>[];
      for (final file in lessonFiles) {
        try {
          final String data = await rootBundle.loadString(file);
          final lesson = Lesson.fromJson(json.decode(data));
          lessons.add(lesson);
        } catch (e) {
          print('Error loading lesson from $file: $e');
        }
      }

      // Sort lessons by title
      lessons.sort((a, b) => a.title.compareTo(b.title));
      return lessons;
    } catch (e) {
      print('Error loading lessons: $e');
      return [];
    }
  }

  Future<Lesson?> getLessonById(String lessonId) async {
    try {
      final String data = await rootBundle.loadString('$_lessonsPath/$lessonId.json');
      return Lesson.fromJson(json.decode(data));
    } catch (e) {
      print('Error loading lesson $lessonId: $e');
      return null;
    }
  }
} 