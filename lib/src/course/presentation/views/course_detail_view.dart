import 'package:education_app/core/common/widgets/course_info_tile.dart';
import 'package:education_app/core/common/widgets/expendable_text.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/extensions/num_extension.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
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
    final course = (widget.course as CourseModel).copyWith(
      numberOfExams: 2,
      numberOfVideos: 2,
      numberOfMaterials: 20,
    );

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
                          tag: 'image-course-hero-${widget.course.id}',
                          child: Image.network(widget.course.image!),
                        )
                      : Image.asset(MediaRes.casualMeditationVect),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ExpandedbleText(
                    context,
                    text: widget.course.description ?? 'No description yet',
                  ),
                  if (course.numberOfExams > 0 ||
                      course.numberOfMaterials > 0 ||
                      course.numberOfVideos > 0) ...[
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Subject Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (course.numberOfVideos > 0) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    CourseInfoTile(
                      image: MediaRes.videoPlaceholderImg,
                      title: '${course.numberOfVideos} Video(s)',
                      subtitle: 'Watch our tutorial videos for ${course.title}',
                      onTap: () => Navigator.of(context)
                          .pushNamed('/unknown-route', arguments: course),
                    )
                  ],
                  if (course.numberOfExams > 0) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    CourseInfoTile(
                      image: MediaRes.videoPlaceholderImg,
                      title: '${course.numberOfExams} Exam(s)',
                      subtitle: 'Take our exam for ${course.title}',
                      onTap: () => Navigator.of(context)
                          .pushNamed('/unknown-route', arguments: course),
                    )
                  ],
                  if (course.numberOfExams > 0) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    CourseInfoTile(
                      image: MediaRes.videoPlaceholderImg,
                      title: '${course.numberOfMaterials} Material(s)',
                      subtitle: 'Access to '
                          '${course.numberOfMaterials.estimate} materials for '
                          '${course.title}',
                      onTap: () => Navigator.of(context)
                          .pushNamed('/unknown-route', arguments: course),
                    )
                  ],
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
