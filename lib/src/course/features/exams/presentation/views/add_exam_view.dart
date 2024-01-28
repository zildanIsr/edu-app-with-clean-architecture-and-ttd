import 'dart:convert';
import 'dart:io';

import 'package:education_app/core/common/widgets/course_picker.dart';
import 'package:education_app/core/enums/notification_enum.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/src/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:education_app/src/notification/presentations/widgets/notification_wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExamView extends StatefulWidget {
  const AddExamView({super.key});

  static const routeName = '/add-exam';

  @override
  State<AddExamView> createState() => _AddExamViewState();
}

class _AddExamViewState extends State<AddExamView> {
  File? examFile;

  bool _showingDialog = false;

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  Future<void> pickedExamFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      setState(() {
        examFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadExam() async {
    if (examFile == null) {
      return CoreUtils.showSnackbar(context, 'Please upload exam');
    }
    if (formKey.currentState!.validate()) {
      final json = examFile!.readAsStringSync();
      final jsonMap = jsonDecode(json) as DataMap;
      final exam = ExamModel.fromUploadMap(jsonMap).copyWith(
        courseId: courseNotifier.value!.id,
      );
      await context.read<ExamCubit>().uploadExam(exam);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onNotificationSent: () {
        Navigator.pop(context);
      },
      child: BlocListener<ExamCubit, ExamState>(
        listener: (context, state) {
          if (_showingDialog == true) {
            Navigator.pop(context);
          }
          if (state is UploadingExam) {
            CoreUtils.showLoadingDialog(context);
            setState(() {
              _showingDialog = true;
            });
          } else if (state is ExamError) {
            CoreUtils.showSnackbar(context, state.message);
          } else if (state is ExamUploaded) {
            CoreUtils.showSnackbar(context, 'Exam added successfully');
            CoreUtils.sendNotification(
              context,
              category: NotificationCategory.TEST,
              title: 'New ${courseNotifier.value!.title}',
              body: 'A new exam has been added for '
                  '${courseNotifier.value!.title}',
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Add Exam'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: CoursePicker(
                        controller: courseController,
                        notifier: courseNotifier,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (examFile != null) ...[
                      Card(
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(MediaRes.json),
                          ),
                          title: Text(examFile!.path.split('/').last),
                          trailing: IconButton(
                            onPressed: () => setState(() {
                              examFile = null;
                            }),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: pickedExamFile,
                          child: Text(
                            examFile == null
                                ? 'Select Exam File'
                                : 'Replace Exam File',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: uploadExam,
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
