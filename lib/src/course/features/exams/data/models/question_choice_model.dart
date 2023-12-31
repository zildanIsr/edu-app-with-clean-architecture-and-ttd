import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/features/exams/domain/entities/question_choice.dart';

class QuestionChoiceModel extends QuestionChoice {
  const QuestionChoiceModel({
    required super.questionId,
    required super.identifier,
    required super.choiceAnswer,
  });

  const QuestionChoiceModel.empty()
      : this(
          questionId: '_empty.questionId',
          identifier: '_empty.identifier',
          choiceAnswer: '_empty.choiceAnswer',
        );

  factory QuestionChoiceModel.fromMap(DataMap map) => QuestionChoiceModel(
        questionId: map['questionId'] as String,
        identifier: map['identifier'] as String,
        choiceAnswer: map['choiceAnswer'] as String,
      );

  factory QuestionChoiceModel.fromUploadMap(DataMap map) => QuestionChoiceModel(
        questionId: map['questionId'] as String? ?? '',
        identifier: map['identifier'] as String,
        choiceAnswer: map['Answer'] as String,
      );

  QuestionChoiceModel copyWith({
    String? questionId,
    String? identifier,
    String? choiceAnswer,
  }) {
    return QuestionChoiceModel(
      questionId: questionId ?? this.questionId,
      identifier: identifier ?? this.identifier,
      choiceAnswer: choiceAnswer ?? this.choiceAnswer,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'questionId': questionId,
      'identifier': identifier,
      'choiceAnswer': choiceAnswer,
    };
  }
}
