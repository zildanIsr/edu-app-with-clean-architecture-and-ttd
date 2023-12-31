import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/features/exams/data/models/user_choice_model.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_choice.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_exam.dart';

class UserExamModel extends UserExam {
  const UserExamModel({
    required super.examId,
    required super.courseId,
    required super.totalQuestions,
    required super.examTitle,
    required super.dateSubmitted,
    required super.answers,
    super.examimageUrl,
  });

  UserExamModel.empty([DateTime? date])
      : this(
          examId: '_test.examId',
          courseId: '_test.courseId',
          totalQuestions: 0,
          examTitle: '_test.examTitle',
          examimageUrl: '_test.examimageUrl',
          dateSubmitted: date ?? DateTime.now(),
          answers: const [],
        );

  factory UserExamModel.fromMap(DataMap map) => UserExamModel(
        examId: map['examId'] as String,
        courseId: map['courseId'] as String,
        totalQuestions: (map['totalQuestions'] as num).toInt(),
        examTitle: map['examTitle'] as String,
        examimageUrl: map['examimageUrl'] as String?,
        dateSubmitted: (map['dateSubmitted'] as Timestamp).toDate(),
        answers: List<DataMap>.from(map['answers'] as List<dynamic>)
            .map(UserChoiceModel.fromMap)
            .toList(),
      );

  UserExamModel copyWith({
    String? examId,
    String? courseId,
    int? totalQuestions,
    String? examTitle,
    String? examimageUrl,
    DateTime? dateSubmitted,
    List<UserChoice>? answers,
  }) {
    return UserExamModel(
      examId: examId ?? this.examId,
      courseId: courseId ?? this.courseId,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      examTitle: examTitle ?? this.examTitle,
      examimageUrl: examimageUrl ?? this.examimageUrl,
      dateSubmitted: dateSubmitted ?? this.dateSubmitted,
      answers: answers ?? this.answers,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'examId': examId,
      'courseId': courseId,
      'totalQuestions': totalQuestions,
      'examTitle': examTitle,
      'examimageUrl': examimageUrl,
      'dateSubmitted': FieldValue.serverTimestamp(),
      'answers':
          answers.map((answer) => (answer as UserChoiceModel).toMap()).toList(),
    };
  }
}
