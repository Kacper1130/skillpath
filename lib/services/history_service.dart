// History Service - manages lesson completion history and quiz attempts
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _historyCollection {
    final uid = _userId;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('history');
  }

  Future<void> saveQuizAttempt(String lessonId, int score, int totalQuestions) async {
    final collection = _historyCollection;
    if (collection == null) return;

    await collection.add({
      'lessonId': lessonId,
      'score': score,
      'totalQuestions': totalQuestions,
      'percentage': ((score / totalQuestions) * 100).round(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getFullHistory() async {
    final collection = _historyCollection;
    if (collection == null) return [];

    final snapshot = await collection.orderBy('timestamp', descending: true).get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<Map<String, dynamic>> getLessonStats(String lessonId) async {
    final collection = _historyCollection;
    if (collection == null) {
      return {'attemptsCount': 0, 'bestScore': 0};
    }

    final snapshot = await collection.where('lessonId', isEqualTo: lessonId).get();

    if (snapshot.docs.isEmpty) {
      return {'attemptsCount': 0, 'bestScore': 0};
    }

    int bestScore = 0;
    for (final doc in snapshot.docs) {
      final percentage = doc.data()['percentage'] as int?;
      if (percentage != null && percentage > bestScore) {
        bestScore = percentage;
      }
    }

    return {
      'attemptsCount': snapshot.docs.length,
      'bestScore': bestScore,
    };
  }
} 