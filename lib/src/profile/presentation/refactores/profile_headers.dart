import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        final img = user?.profilePic;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: img != null
                  ? NetworkImage(img)
                  : const AssetImage(MediaRes.defaultUserImg) as ImageProvider,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              user?.fullName ?? 'User Name',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (user?.bio != null && user!.bio!.isNotEmpty) ...[
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widht * .15,
                ),
                child: Text(
                  user.bio!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colours.neutralTextColour,
                  ),
                ),
              )
            ],
            const SizedBox(
              height: 16,
            ),
          ],
        );
      },
    );
  }
}
