import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/src/course/features/exams/presentation/views/add_exam_view.dart';
import 'package:education_app/src/course/features/materials/presentation/views/add_materials_view.dart';
import 'package:education_app/src/course/features/videos/presentation/views/add_video_view.dart';
import 'package:education_app/src/home/presentations/widgets/floating_action_btn.dart';
import 'package:education_app/src/profile/presentation/refactores/profile_body.dart';
import 'package:education_app/src/profile/presentation/refactores/profile_headers.dart';
import 'package:education_app/src/profile/presentation/widgets/profile_app_bar_menu.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final widget = <Widget>[];
    if (context.currentUser!.isAdmin) {
      widget.add(
        ExpandableFab(
          distance: 100,
          children: [
            ActionButton(
              onPressed: () {},
              icon: const Icon(IconlyLight.paper_upload),
            ),
            ActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AddVideoView.routeName);
              },
              icon: const Icon(IconlyLight.video),
            ),
            ActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AddMaterialView.routeName);
              },
              icon: const Icon(IconlyLight.document),
            ),
            ActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AddExamView.routeName);
              },
              icon: const Icon(IconlyLight.paper_download),
            ),
          ],
        ),
      );
    } else {
      widget.add(const SizedBox.shrink());
    }

    return Scaffold(
      appBar: const ProfileAppBar(),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: const [
            ProfileHeader(),
            ProfileBody(),
          ],
        ),
      ),
      floatingActionButton: widget[0],
    );
  }
}
