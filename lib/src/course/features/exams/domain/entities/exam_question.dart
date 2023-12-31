import 'package:education_app/src/course/features/exams/domain/entities/question_choice.dart';
import 'package:equatable/equatable.dart';

class ExamQuestion extends Equatable {
  const ExamQuestion({
    required this.id,
    required this.courseId,
    required this.examId,
    required this.questionText,
    required this.choices,
    this.correctAnswer,
  });

  const ExamQuestion.empty()
      : this(
          id: '_empty.id',
          courseId: '_empty.courseid',
          examId: '_empty.examId',
          questionText: '_empty.questionText',
          choices: const [],
          correctAnswer: '_exam.correcAnswer',
        );

  final String id;
  final String courseId;
  final String examId;
  final String questionText;
  final String? correctAnswer;
  final List<QuestionChoice> choices;

  @override
  List<Object?> get props => [id, examId, courseId];
}
