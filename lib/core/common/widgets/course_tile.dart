import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:flutter/material.dart';

class CourseTile extends StatelessWidget {
  const CourseTile({
    required this.course,
    super.key,
    this.onTap,
    this.isHero = false,
  });

  final Course course;
  final bool isHero;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            SizedBox(
              height: 68,
              width: 68,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isHero
                    ? Hero(
                        tag: 'image-course-hero-${course.id}',
                        transitionOnUserGestures: true,
                        child: Image.network(
                          course.image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.network(
                        course.image!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              course.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
