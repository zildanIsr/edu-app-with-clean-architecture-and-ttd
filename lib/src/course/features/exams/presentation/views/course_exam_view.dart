import 'package:education_app/core/common/views/loading.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/extensions/int_extenstion.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:education_app/src/course/features/exams/presentation/views/course_exam_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseExamsView extends StatefulWidget {
  const CourseExamsView(this.course, {super.key});

  static const routeName = '/course-exams';

  final Course course;

  @override
  State<CourseExamsView> createState() => _CourseExamsViewState();
}

class _CourseExamsViewState extends State<CourseExamsView> {
  void getExams() {
    context.read<ExamCubit>().getExams(widget.course.id);
  }

  @override
  void initState() {
    super.initState();
    getExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${widget.course.title} Exams'),
        leading: const NestedBackButton(),
      ),
      body: BlocConsumer<ExamCubit, ExamState>(
        listener: (_, state) {
          if (state is ExamError) {
            CoreUtils.showSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is GettingExams) {
            return const LoadingView();
          } else if ((state is ExamsLoaded && state.exams.isEmpty) ||
              state is ExamError) {
            return NotFoundText(
              text: 'No exams found for ${widget.course.title}',
            );
          } else if (state is ExamsLoaded) {
            return SafeArea(
              child: ListView.builder(
                itemCount: state.exams.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                itemBuilder: (_, index) {
                  final exam = state.exams[index];
                  return Stack(
                    children: [
                      Card(
                        margin: const EdgeInsets.all(4).copyWith(bottom: 30),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                exam.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                exam.description,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                exam.timeLimit.displayDuration,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.widht * .2,
                            vertical: 10,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                CourseDetailExam.routeName,
                                arguments: exam,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Take Exam'),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
