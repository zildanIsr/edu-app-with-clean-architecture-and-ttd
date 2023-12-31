import 'dart:async';

import 'package:education_app/core/common/widgets/pop_up_item.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:education_app/src/profile/presentation/views/edit_profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Account',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_horiz_rounded),
          iconSize: 32,
          surfaceTintColor: Colors.white,
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          itemBuilder: (_) => [
            PopupMenuItem<void>(
              onTap: () => context.push(
                BlocProvider(
                  create: (_) => sl<AuthenticationBloc>(),
                  child: const EditProfileView(),
                ),
              ),
              child: const PopupItem(
                tittle: 'Edit Profile',
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colours.neutralTextColour,
                ),
              ),
            ),
            PopupMenuItem<void>(
              height: 1,
              child: Divider(
                height: 1,
                color: Colors.grey.shade300,
                indent: 16,
                endIndent: 16,
              ),
            ),
            PopupMenuItem<void>(
              onTap: () => context.push(const Placeholder()),
              child: const PopupItem(
                tittle: 'Settings',
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colours.neutralTextColour,
                ),
              ),
            ),
            PopupMenuItem<void>(
              height: 1,
              child: Divider(
                height: 1,
                color: Colors.grey.shade300,
                indent: 16,
                endIndent: 16,
              ),
            ),
            PopupMenuItem<void>(
              onTap: () => context.push(const Placeholder()),
              child: const PopupItem(
                tittle: 'Help',
                icon: Icon(
                  Icons.help_outline_outlined,
                  color: Colours.neutralTextColour,
                ),
              ),
            ),
            PopupMenuItem<void>(
              height: 1,
              child: Divider(
                height: 1,
                color: Colors.grey.shade300,
                indent: 16,
                endIndent: 16,
              ),
            ),
            PopupMenuItem<void>(
              onTap: () async {
                final navigator = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                unawaited(
                  navigator.pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  ),
                );
              },
              child: const PopupItem(
                tittle: 'Logout',
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colours.redColour,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
