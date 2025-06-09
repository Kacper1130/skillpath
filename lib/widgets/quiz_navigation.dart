import 'package:flutter/material.dart';

class QuizNavigation extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final int? selectedAnswer;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const QuizNavigation({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.selectedAnswer,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLastQuestion = currentIndex == totalQuestions - 1;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: currentIndex > 0 ? onPrevious : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: currentIndex > 0
                    ? colorScheme.outline
                    : colorScheme.outline.withOpacity(0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: currentIndex > 0
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  'Previous',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: currentIndex > 0
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: selectedAnswer != null ? onNext : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: selectedAnswer != null
                  ? colorScheme.primary
                  : colorScheme.primary.withOpacity(0.5),
              foregroundColor: colorScheme.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastQuestion ? 'Finish' : 'Next',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isLastQuestion) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: colorScheme.onPrimary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
} 