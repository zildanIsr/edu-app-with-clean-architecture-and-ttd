import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class Tindercard extends StatelessWidget {
  const Tindercard({required this.isFirst, super.key, this.colour});

  final bool isFirst;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          height: 137,
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            gradient: isFirst
                ? const LinearGradient(
                    colors: [Color(0xFF8E96FF), Color(0xFFA06AF9)],
                  )
                : null,
            color: colour,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.15),
                offset: const Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child: isFirst
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${context.courseOfTheDay?.title ?? 'Lessons'}'
                      ' final\nexams',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(
                          IconlyLight.notification,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '45 minutes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : null,
        ),
        if (isFirst)
          Positioned(
            bottom: 10,
            right: 10,
            child: Image.asset(
              MediaRes.microscopeVect,
              height: 180,
              width: 149,
            ),
          ),
      ],
    );
  }
}
