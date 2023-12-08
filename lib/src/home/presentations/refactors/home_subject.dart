import 'package:education_app/core/common/widgets/course_tile.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/presentation/views/all_courses_view.dart';
import 'package:education_app/src/course/presentation/views/course_detail_view.dart';
import 'package:education_app/src/home/presentations/widgets/section_header.dart';
import 'package:flutter/material.dart';

class HomeSubjects extends StatelessWidget {
  const HomeSubjects({required this.courses, super.key});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          onSeeAll: () => context.push(
            AllCourseView(
              courses: courses,
            ),
          ),
          sectionTitle: 'Courses',
          seeAll: courses.length > 4,
        ),
        const Text(
          'Explore our courses',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colours.neutralTextColour,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: courses
              .take(4)
              .map(
                (course) => CourseTile(
                  course: course,
                  onTap: () => Navigator.of(context)
                      .pushNamed(CourseDetailView.routeName, arguments: course),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
