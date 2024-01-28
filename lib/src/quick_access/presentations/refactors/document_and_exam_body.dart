import 'package:education_app/core/common/widgets/course_tile.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:education_app/src/course/features/exams/presentation/views/course_exam_view.dart';
import 'package:education_app/src/course/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:education_app/src/course/features/materials/presentation/views/course_material_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentAndExamBody extends StatelessWidget {
  const DocumentAndExamBody({
    required this.course,
    required this.index,
    super.key,
  });

  final List<Course> course;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20).copyWith(top: 0),
      children: [
        Center(
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            runAlignment: WrapAlignment.spaceEvenly,
            children: course.map((course) {
              return CourseTile(
                course: course,
                onTap: () {
                  context.push(
                    index == 0
                        ? BlocProvider(
                            create: (context) => sl<MaterialCubit>(),
                            child: CourseMaterialView(course),
                          )
                        : BlocProvider(
                            create: (context) => sl<ExamCubit>(),
                            child: CourseExamsView(course),
                          ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
