import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/domain/entities/course.dart';

abstract class CourseRepo {
  const CourseRepo();

  ResultFuture<List<Course>> getCourse();

  ResultFuture<void> addCourse(Course course);
}
