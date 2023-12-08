part of 'course_cubit.dart';

sealed class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

final class CourseInitial extends CourseState {
  const CourseInitial();
}

class LoadingCourse extends CourseState {
  const LoadingCourse();
}

class AddingCourse extends CourseState {
  const AddingCourse();
}

class CourseAdded extends CourseState {
  const CourseAdded();
}

class CoursesLoaded extends CourseState {
  const CoursesLoaded(this.courses);

  final List<Course> courses;

  @override
  List<Object> get props => [courses];
}

class CourseError extends CourseState {
  const CourseError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
