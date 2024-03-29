import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_choice.dart';
import 'package:flutter/material.dart';

class ExamHistoryAnswerTile extends StatelessWidget {
  const ExamHistoryAnswerTile(this.answer, {required this.index, super.key});

  final UserChoice answer;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      expandedAlignment: Alignment.centerLeft,
      title: Text(
        'Question ${index + 1}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        answer.isCorrect ? 'Right' : 'Wrong',
        style: TextStyle(
          color: answer.isCorrect ? Colours.greenColour : Colours.redColour,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Text(
          'Your Answer ${answer.userChoice}',
          style: TextStyle(
            color: answer.isCorrect ? Colours.greenColour : Colours.redColour,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
