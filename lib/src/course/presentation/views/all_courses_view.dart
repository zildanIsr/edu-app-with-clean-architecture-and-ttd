import 'package:education_app/core/common/widgets/course_tile.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/presentation/views/course_detail_view.dart';
import 'package:flutter/material.dart';

class AllCourseView extends StatelessWidget {
  const AllCourseView({required this.courses, super.key});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const NestedBackButton(),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'All Subjects',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 40,
                  runAlignment: WrapAlignment.spaceEvenly,
                  children: courses
                      .map(
                        (course) => CourseTile(
                          course: course,
                          onTap: () => Navigator.of(context).pushNamed(
                            CourseDetailView.routeName,
                            arguments: course,
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
