import 'package:bloc/bloc.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/usecase/add_course_use_case.dart';
import 'package:education_app/src/course/domain/usecase/get_course_use_case.dart';
import 'package:equatable/equatable.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit({
    required AddCourse addCourse,
    required GetCourse getCourse,
  })  : _addCourse = addCourse,
        _getCourse = getCourse,
        super(const CourseInitial());

  final AddCourse _addCourse;
  final GetCourse _getCourse;

  Future<void> addCourse(Course course) async {
    emit(const AddingCourse());

    final result = await _addCourse(course);
    result.fold(
      (failure) => emit(CourseError(failure.errorMessage)),
      (_) => emit(const CourseAdded()),
    );
  }

  Future<void> getCourse() async {
    emit(const LoadingCourse());

    final result = await _getCourse();
    result.fold(
      (failure) => emit(CourseError(failure.errorMessage)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }
}
