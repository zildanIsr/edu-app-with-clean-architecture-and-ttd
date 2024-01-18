import 'package:education_app/core/common/app/providers/notification_notifier.dart';
import 'package:education_app/core/common/widgets/pop_up_item.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/notification/presentations/cubit/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsOptions extends StatelessWidget {
  const NotificationsOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsNotifier>(
      builder: (_, notifier, __) {
        return PopupMenuButton(
          offset: const Offset(0, 50),
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          itemBuilder: (context) => [
            PopupMenuItem<void>(
              onTap: notifier.toggleMuteNotifications,
              child: PopupItem(
                tittle: notifier.muteNotifications
                    ? 'Un-mute Notification'
                    : 'Mute notification',
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colours.neutralTextColour,
                ),
              ),
            ),
            PopupMenuItem<void>(
              onTap: context.read<NotificationsCubit>().clearAll,
              child: const PopupItem(
                tittle: 'Clear All',
                icon: Icon(
                  Icons.check_circle_outline_outlined,
                  color: Colours.neutralTextColour,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
