import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/src/course/presentation/widgets/add_course_sheet.dart';
import 'package:education_app/src/profile/presentation/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            const SizedBox(
              height: 30,
            ),
            if (context.currentUser!.isAdmin) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colours.primaryColour,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(IconlyLight.paper_upload),
                  label: const Text('Add Course'),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      showDragHandle: true,
                      elevation: 0,
                      useSafeArea: true,
                      context: context,
                      builder: (_) => BlocProvider(
                        create: (_) => sl<CourseCubit>(),
                        child: const AddCurseSheet(),
                      ),
                    );
                  },
                ),
              )
            ]
          ],
        );
      },
    );
  }
}
