import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/src/profile/presentation/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          //padding: const EdgeInsets.symmetric(horizontal: 10),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 16 / 9,
          children: [
            UserInfoCard(
              icon: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.purple.shade50,
                child: Icon(
                  IconlyLight.document,
                  size: 30,
                  color: Colors.purple.shade300,
                ),
              ),
              tittle: 'Courses',
              count: user!.enrolledCourseIds.length.toString(),
            ),
            UserInfoCard(
              icon: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.green.shade50,
                child: Icon(
                  IconlyLight.activity,
                  size: 30,
                  color: Colors.green.shade300,
                ),
              ),
              tittle: 'Scores',
              count: user.points.toString(),
            ),
            UserInfoCard(
              icon: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.shade50,
                child: Icon(
                  IconlyLight.user,
                  size: 30,
                  color: Colors.blue.shade300,
                ),
              ),
              tittle: 'Followers',
              count: user.followers.length.toString(),
            ),
            UserInfoCard(
              icon: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.pink.shade50,
                child: Icon(
                  IconlyLight.user,
                  size: 30,
                  color: Colors.pink.shade300,
                ),
              ),
              tittle: 'Following',
              count: user.followings.length.toString(),
            ),
          ],
        );
      },
    );
  }
}
