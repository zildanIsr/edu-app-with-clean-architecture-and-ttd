import 'package:education_app/core/common/views/loading.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/src/quick_access/presentations/provider/quick_access_tab_controller.dart';
import 'package:education_app/src/quick_access/presentations/refactors/document_and_exam_body.dart';
import 'package:education_app/src/quick_access/presentations/refactors/exam_history_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class QuickAccessTabBody extends StatefulWidget {
  const QuickAccessTabBody({super.key});

  @override
  State<QuickAccessTabBody> createState() => _QuickAccessTabBodyState();
}

class _QuickAccessTabBodyState extends State<QuickAccessTabBody> {
  @override
  void initState() {
    context.read<CourseCubit>().getCourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (_, state) {
        if (state is CourseError) {
          CoreUtils.showSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is LoadingCourse) {
          return const LoadingView();
        } else if ((state is CoursesLoaded && state.courses.isEmpty) ||
            state is CourseError) {
          return const NotFoundText(
            text: 'No Course found\nOr Something Error',
          );
        } else if (state is CoursesLoaded) {
          final course = state.courses
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          return Consumer<QuickAccTabController>(
            builder: (_, controller, __) {
              switch (controller.currentIndex) {
                case 0:
                case 1:
                  return DocumentAndExamBody(
                    course: course,
                    index: controller.currentIndex,
                  );
                default:
                  return BlocProvider(
                    create: (_) => sl<ExamCubit>(),
                    child: const ExamHistoryBody(),
                  );
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
