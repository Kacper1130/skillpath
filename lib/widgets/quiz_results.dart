import 'package:flutter/material.dart';
import '../models/lesson.dart';

class QuizResults extends StatelessWidget {
  final List<Question> questions;
  final List<int?> userAnswers;
  final List<bool> answerResults;
  final VoidCallback onRetry;

  const QuizResults({
    super.key,
    required this.questions,
    required this.userAnswers,
    required this.answerResults,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final correctAnswers = answerResults.where((result) => result).length;
    final score = (correctAnswers / questions.length * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiz Completed!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$correctAnswers out of ${questions.length} correct',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$score%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question Review',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              final userAnswer = userAnswers[index];
              final isCorrect = answerResults[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? colorScheme.primaryContainer
                                  : colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isCorrect ? Icons.check : Icons.close,
                              color: isCorrect
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onErrorContainer,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Question ${index + 1}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question.question,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your answer: ${userAnswer != null ? question.answers[userAnswer] : 'Not answered'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isCorrect
                              ? colorScheme.primary
                              : colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!isCorrect) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Correct answer: ${question.answers[question.correctAnswer]}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 