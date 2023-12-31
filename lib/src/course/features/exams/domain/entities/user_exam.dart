// users >> userId >> courses >> courseId >> exams >> examId >> answer

import 'package:education_app/src/course/features/exams/domain/entities/user_choice.dart';
import 'package:equatable/equatable.dart';

/// Display the user's exam history, we can fetch
/// the actual exam by the ['examId'] and then display the questions.

class UserExam extends Equatable {
  const UserExam({
    required this.examId,
    required this.courseId,
    required this.totalQuestions,
    required this.examTitle,
    required this.dateSubmitted,
    required this.answers,
    this.examimageUrl,
  });

  UserExam.empty([DateTime? date])
      : this(
          examId: '_test.examId',
          courseId: '_test.courseId',
          totalQuestions: 0,
          examTitle: '_test.examTitle',
          examimageUrl: '_test.examImageUrl',
          dateSubmitted: date ?? DateTime.now(),
          answers: const [],
        );

  final String examId;
  final String courseId;
  final int totalQuestions;
  final String examTitle;
  final String? examimageUrl;
  final DateTime dateSubmitted;
  final List<UserChoice> answers;

  @override
  List<Object?> get props => [examId, courseId];
}
