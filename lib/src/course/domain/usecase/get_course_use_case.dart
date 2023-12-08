import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repos/course_repo.dart';

class GetCourse extends UsecaseWithoutParams<List<Course>> {
  const GetCourse(this._repository);

  final CourseRepo _repository;

  @override
  ResultFuture<List<Course>> call() => _repository.getCourse();
}
