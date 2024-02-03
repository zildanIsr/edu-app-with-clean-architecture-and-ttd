import 'package:badges/badges.dart' as badges;
import 'package:education_app/core/common/views/loading.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/notification/presentations/cubit/notifications_cubit.dart';
import 'package:education_app/src/notification/presentations/widgets/empty_notification.dart';
import 'package:education_app/src/notification/presentations/widgets/notification_options.dart';
import 'package:education_app/src/notification/presentations/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    context.read<NotificationsCubit>().getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
        leading: const NestedBackButton(),
        actions: [
          BlocProvider(
            create: (context) => sl<NotificationsCubit>(),
            child: const NotificationsOptions(),
          ),
        ],
      ),
      body: BlocConsumer<NotificationsCubit, NotificationsState>(
        listener: (context, state) {
          if (state is NotificationError) {
            CoreUtils.showSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is GettingNotifications) {
            return const LoadingView();
          } else if (state is NotificationsLoaded &&
              state.notifications.isEmpty) {
            return const EmptyNotifications();
          } else if (state is NotificationsLoaded) {
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (_, index) {
                final notification = state.notifications[index];
                return badges.Badge(
                  showBadge: !notification.seen,
                  position: badges.BadgePosition.topEnd(top: 30, end: 20),
                  child: BlocProvider(
                    create: (context) => sl<NotificationsCubit>(),
                    child: NotificationTile(
                      notification: notification,
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
