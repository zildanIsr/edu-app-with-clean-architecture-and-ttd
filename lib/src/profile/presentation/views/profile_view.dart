import 'package:education_app/src/profile/presentation/refactores/profile_body.dart';
import 'package:education_app/src/profile/presentation/refactores/profile_headers.dart';
import 'package:education_app/src/profile/presentation/widgets/profile_app_bar_menu.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
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
    );
  }
}
