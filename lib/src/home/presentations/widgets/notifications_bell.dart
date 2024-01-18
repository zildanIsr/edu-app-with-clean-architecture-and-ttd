import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart' as badges;
import 'package:education_app/core/common/app/providers/notification_notifier.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/notification/presentations/cubit/notifications_cubit.dart';
import 'package:education_app/src/notification/presentations/views/notifications_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class NotificationsBell extends StatefulWidget {
  const NotificationsBell({super.key});

  @override
  State<NotificationsBell> createState() => _NotificationsBellState();
}

class _NotificationsBellState extends State<NotificationsBell> {
  final newNotificationListenable = ValueNotifier<bool>(false);
  int? notificationsCount;
  final player = AudioPlayer();

  @override
  void initState() {
    context.read<NotificationsCubit>().getNotifications();
    newNotificationListenable.addListener(() {
      if (newNotificationListenable.value) {
        if (!context.read<NotificationsNotifier>().muteNotifications) {
          player.play(AssetSource('sounds/notification_sound.mp3'));
        }
        newNotificationListenable.value = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (_, state) {
        if (state is NotificationsLoaded) {
          if (notificationsCount != null) {
            if (notificationsCount! < state.notifications.length) {
              newNotificationListenable.value = true;
            }
          }
          notificationsCount = state.notifications.length;
        } else if (state is NotificationError) {
          CoreUtils.showSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is NotificationsLoaded) {
          final unseenNotificationsLength = state.notifications
              .where((notifications) => !notifications.seen)
              .length;
          final showBadge = unseenNotificationsLength > 0;
          return GestureDetector(
            onTap: () {
              context.push(
                BlocProvider.value(
                  value: sl<NotificationsCubit>(),
                  child: const NotificationsView(),
                ),
              );
            },
            child: badges.Badge(
              showBadge: showBadge,
              position: badges.BadgePosition.topEnd(end: -2),
              badgeContent: unseenNotificationsLength <= 10
                  ? Text(
                      unseenNotificationsLength.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    )
                  : null,
              child: const Icon(IconlyLight.notification),
            ),
          );
        }
        return const Icon(IconlyLight.notification);
      },
    );
  }
}
