import 'package:education_app/core/common/app/providers/tab_navigator.dart';
import 'package:education_app/core/common/views/persistent_view.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:education_app/src/chat/presentation/views/group_chat_view.dart';
import 'package:education_app/src/course/features/videos/presentation/cubit/videos_cb_cubit.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/src/home/presentations/views/home_view.dart';
import 'package:education_app/src/notification/presentations/cubit/notifications_cubit.dart';

import 'package:education_app/src/profile/presentation/views/profile_view.dart';
import 'package:education_app/src/quick_access/presentations/provider/quick_access_tab_controller.dart';
import 'package:education_app/src/quick_access/presentations/views/quick_access_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl<CourseCubit>(),
              ),
              BlocProvider(
                create: (_) => sl<VideosCbCubit>(),
              ),
              BlocProvider.value(
                value: sl<NotificationsCubit>(),
              ),
            ],
            child: const HomeView(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: BlocProvider(
            create: (context) => sl<CourseCubit>(),
            child: ChangeNotifierProvider(
              create: (context) => QuickAccTabController(),
              child: const QuickAccessView(),
            ),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: BlocProvider(
            create: (_) => sl<ChatCubit>(),
            child: const GroupChatView(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const ProfileView(),
        ),
      ),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;
  int _currentIndex = 3;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
