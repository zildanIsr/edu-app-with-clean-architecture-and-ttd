import 'package:equatable/equatable.dart';

class UserChoice extends Equatable {
  const UserChoice({
    required this.userChoice,
    required this.questionId,
    required this.correctChoice,
  });

  const UserChoice.empty()
      : this(
          questionId: '_test.questionId',
          correctChoice: '_test.correctChoice',
          userChoice: '_test.userChoice',
        );

  final String userChoice;
  final String questionId;
  final String correctChoice;

  bool get isCorrect => userChoice == correctChoice;

  @override
  List<Object> get props => [userChoice, questionId, correctChoice];

  @override
  bool get stringify => true;
}
