import 'package:education_app/core/common/views/loading.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:education_app/src/quick_access/presentations/widgets/exam_history_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamHistoryBody extends StatefulWidget {
  const ExamHistoryBody({super.key});

  @override
  State<ExamHistoryBody> createState() => _ExamHistoryBodyState();
}

class _ExamHistoryBodyState extends State<ExamHistoryBody> {
  void _getHistory() {
    context.read<ExamCubit>().getuserExams();
  }

  @override
  void initState() {
    _getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamCubit, ExamState>(
      listener: (_, state) {
        if (state is ExamError) {
          CoreUtils.showSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is GettingUserExams) {
          return const LoadingView();
        } else if ((state is UserExamsLoaded && state.exams.isEmpty) ||
            state is ExamError) {
          return const NotFoundText(
            text: 'No history exam yet',
          );
        } else if (state is UserExamsLoaded) {
          final exams = state.exams
            ..sort((a, b) => b.dateSubmitted.compareTo(a.dateSubmitted));
          return ListView.builder(
            itemCount: exams.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, int index) {
              final exam = exams[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExamHistoryTile(exam),
                  if (index != exams.length - 1)
                    const SizedBox(
                      height: 20,
                    ),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
