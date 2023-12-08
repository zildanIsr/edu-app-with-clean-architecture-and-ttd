import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:flutter/material.dart';

class CourseDetailView extends StatefulWidget {
  const CourseDetailView({required this.course, super.key});

  static const routeName = '/detail-course';
  final Course course;

  @override
  State<CourseDetailView> createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<CourseDetailView> {
  @override
  Widget build(BuildContext context) {
    //final course = ModalRoute.of(context)!.settings.arguments! as Course;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.course.title),
        centerTitle: true,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SizedBox(
                height: context.height * .3,
                child: Center(
                  child: widget.course.image != null
                      ? Hero(
                          tag: 'image-course-hero',
                          child: Image.network(widget.course.image!),
                        )
                      : Image.asset(MediaRes.casualMeditationVect),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
