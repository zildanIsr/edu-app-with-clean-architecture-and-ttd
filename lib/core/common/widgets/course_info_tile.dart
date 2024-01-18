import 'package:education_app/core/res/colours.dart';
import 'package:flutter/material.dart';

class CourseInfoTile extends StatelessWidget {
  const CourseInfoTile({
    required this.image,
    required this.title,
    required this.subtitle,
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;
  final String image;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(
              image,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colours.neutralTextColour,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
