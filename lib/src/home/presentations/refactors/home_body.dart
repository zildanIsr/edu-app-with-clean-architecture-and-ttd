import 'package:education_app/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:education_app/core/common/views/loading.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/src/home/presentations/refactors/home_body_header.dart';
import 'package:education_app/src/home/presentations/refactors/home_subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void getCourse() {
    context.read<CourseCubit>().getCourse();
  }

  @override
  void initState() {
    super.initState();
    getCourse();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (_, state) {
        if (state is CourseError) {
          CoreUtils.showSnackbar(context, state.message);
        } else if (state is CoursesLoaded && state.courses.isNotEmpty) {
          final courseData = state.courses..shuffle();
          final courseOfTheDay = courseData.first;
          context
              .read<CourseOfTheDayNotifier>()
              .setCourseOfTheDay(courseOfTheDay);
        }
      },
      builder: (context, state) {
        if (state is LoadingCourse) {
          return const LoadingView();
        } else if (state is CoursesLoaded && state.courses.isEmpty ||
            state is CourseError) {
          return const NotFoundText(
            text: 'No courses found\nPlease contact admin or if you are '
                'admin add course.',
          );
        } else if (state is CoursesLoaded) {
          final courses = state.courses
            ..sort(
              (a, b) => b.updatedAt.compareTo(a.updatedAt),
            );

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const HomeBodyHeader(),
              const SizedBox(height: 20),
              HomeSubjects(
                courses: courses,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
