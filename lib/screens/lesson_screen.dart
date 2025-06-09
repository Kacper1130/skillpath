import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/lesson.dart';
import '../widgets/quiz_navigation.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_results.dart';
import '../services/history_service.dart';

class LessonScreen extends StatefulWidget {
  final String lessonId;
  final Function(int)? onQuizCompleted;

  const LessonScreen({
    super.key,
    required this.lessonId,
    this.onQuizCompleted,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with SingleTickerProviderStateMixin {
  Lesson? lesson;
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  bool quizCompleted = false;
  bool quizStarted = false;
  List<bool> answerResults = [];
  List<int?> userAnswers = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    loadLesson();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadLesson() async {
    final String data = await rootBundle.loadString('assets/lessons/${widget.lessonId}.json');
    final loadedLesson = Lesson.fromJson(json.decode(data));
    setState(() {
      lesson = loadedLesson;
      answerResults = List.filled(loadedLesson.quiz.length, false);
      userAnswers = List.filled(loadedLesson.quiz.length, null);
    });
    _animationController.forward();
  }

  void startQuiz() {
    setState(() {
      quizStarted = true;
    });
  }

  void selectAnswer(int answerIndex) {
    setState(() {
      selectedAnswer = answerIndex;
      userAnswers[currentQuestionIndex] = answerIndex;
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < lesson!.quiz.length - 1) {
      _animationController.reverse().then((_) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswer = userAnswers[currentQuestionIndex];
        });
        _animationController.forward();
      });
    } else {
      final results = <bool>[];
      for (int i = 0; i < lesson!.quiz.length; i++) {
        results.add(userAnswers[i] == lesson!.quiz[i].correctAnswer);
      }
      _animationController.reverse().then((_) {
        setState(() {
          quizCompleted = true;
          answerResults = results;
        });
        _animationController.forward();

        // Calculate score and update progress
        final correctAnswers = results.where((result) => result).length;
        final score = (correctAnswers / lesson!.quiz.length * 100).round();
        
        // Update progress
        _historyService.updateQuizScore(lesson!, score);
        _historyService.markLessonCompleted(lesson!);
        
        // Notify parent
        widget.onQuizCompleted?.call(score);
      });
    }
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      _animationController.reverse().then((_) {
        setState(() {
          currentQuestionIndex--;
          selectedAnswer = userAnswers[currentQuestionIndex];
        });
        _animationController.forward();
      });
    }
  }

  void retryQuiz() {
    setState(() {
      quizStarted = true;
      quizCompleted = false;
      currentQuestionIndex = 0;
      selectedAnswer = null;
      answerResults = List.filled(lesson!.quiz.length, false);
      userAnswers = List.filled(lesson!.quiz.length, null);
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (lesson == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading lesson...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson!.title),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!quizStarted) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson!.content,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: startQuiz,
                                icon: const Icon(Icons.quiz),
                                label: const Text('Start Quiz'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else if (!quizCompleted) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Question ${currentQuestionIndex + 1} of ${lesson!.quiz.length}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: QuestionCard(
                        question: lesson!.quiz[currentQuestionIndex],
                        selectedAnswer: selectedAnswer,
                        onAnswerSelected: selectAnswer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  QuizNavigation(
                    currentIndex: currentQuestionIndex,
                    totalQuestions: lesson!.quiz.length,
                    selectedAnswer: selectedAnswer,
                    onPrevious: goToPreviousQuestion,
                    onNext: goToNextQuestion,
                  ),
                ] else
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: QuizResults(
                        questions: lesson!.quiz,
                        userAnswers: userAnswers,
                        answerResults: answerResults,
                        onRetry: retryQuiz,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 