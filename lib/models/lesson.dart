class Lesson {
  final String id;
  final String title;
  final String content;
  final List<Question> quiz;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.quiz,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    try {
      return Lesson(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? 'No Title',
        content: json['content']?.toString() ?? 'No Content',
        quiz: json['quiz'] != null 
            ? (json['quiz'] as List).map((q) => Question.fromJson(q as Map<String, dynamic>)).toList()
            : [],
      );
    } catch (e) {
      print('Error parsing lesson JSON: $e');
      return Lesson(
        id: json['id']?.toString() ?? 'error',
        title: 'Error Loading Lesson',
        content: 'There was an error loading this lesson. Please try again later.',
        quiz: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'quiz': quiz.map((q) => q.toJson()).toList(),
    };
  }
}

class Question {
  final String question;
  final List<String> answers;
  final int correctAnswer;

  Question({
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    try {
      return Question(
        question: json['question']?.toString() ?? 'No Question',
        answers: json['answers'] != null 
            ? List<String>.from(json['answers'].map((x) => x.toString()))
            : ['No Answer'],
        correctAnswer: json['correctAnswer'] is int 
            ? json['correctAnswer'] as int 
            : 0,
      );
    } catch (e) {
      print('Error parsing question JSON: $e');
      return Question(
        question: 'Error Loading Question',
        answers: ['Error'],
        correctAnswer: 0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers,
      'correctAnswer': correctAnswer,
    };
  }
} 