import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repos/course_repo.dart';

class AddCourse extends UsecaseWithParams<void, Course> {
  const AddCourse(this._repository);

  final CourseRepo _repository;
  @override
  ResultFuture<void> call(Course params) => _repository.addCourse(params);
}
