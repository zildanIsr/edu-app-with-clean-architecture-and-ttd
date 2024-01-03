import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_choice.dart';

class UserChoiceModel extends UserChoice {
  const UserChoiceModel({
    required super.userChoice,
    required super.questionId,
    required super.correctChoice,
  });

  const UserChoiceModel.empty()
      : this(
          userChoice: '_test.answer',
          questionId: '_test.questionId',
          correctChoice: '_test.answer',
        );

  factory UserChoiceModel.fromMap(Map<String, dynamic> map) {
    return UserChoiceModel(
      userChoice: map['userChoice'] as String,
      questionId: map['questionId'] as String,
      correctChoice: map['correctChoice'] as String,
    );
  }

  UserChoiceModel copyWith({
    String? userChoice,
    String? questionId,
    String? correctChoice,
  }) {
    return UserChoiceModel(
      userChoice: userChoice ?? this.userChoice,
      questionId: questionId ?? this.questionId,
      correctChoice: correctChoice ?? this.correctChoice,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'userChoice': userChoice,
      'questionId': questionId,
      'correctChoice': correctChoice,
    };
  }
}
