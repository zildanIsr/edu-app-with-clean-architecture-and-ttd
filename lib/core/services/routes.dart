import 'package:education_app/core/common/views/page_under_construction.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:education_app/src/authentication/presentation/views/forgot_password_view.dart';
import 'package:education_app/src/authentication/presentation/views/sign_in_screen.dart';
import 'package:education_app/src/authentication/presentation/views/sign_up_screen.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:education_app/src/course/features/exams/presentation/views/add_exam_view.dart';
import 'package:education_app/src/course/features/materials/presentation/cubit/material_cubit.dart';
import 'package:education_app/src/course/features/materials/presentation/views/add_materials_view.dart';
import 'package:education_app/src/course/features/videos/presentation/cubit/videos_cb_cubit.dart';
import 'package:education_app/src/course/features/videos/presentation/views/add_video_view.dart';
import 'package:education_app/src/course/features/videos/presentation/views/course_videos_view.dart';
import 'package:education_app/src/course/features/videos/presentation/views/video_player_view.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/src/course/presentation/views/course_detail_view.dart';
import 'package:education_app/src/dashboard/presentation/views/dasboard_screen.dart';
import 'package:education_app/src/notification/presentations/cubit/notifications_cubit.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_board_local_data_source.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cb_cubit.dart';
import 'package:education_app/src/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          if (prefs.getBool(kFirstTimeKey) ?? true) {
            return BlocProvider(
              create: (_) => sl<OnBoardingCbCubit>(),
              child: const OnBoardingView(),
            );
          } else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;
            final localUser = UserModel(
              uid: user.uid,
              email: user.email ?? '',
              points: 0,
              fullName: user.displayName ?? '',
            );
            context.userProvider.initUser(localUser);
            return const DashboardScreen();
          }
          return BlocProvider(
            create: (_) => sl<AuthenticationBloc>(),
            child: const SignInScreen(),
          );
        },
        settings: settings,
      );
    case SignInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthenticationBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case SignUpSreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthenticationBloc>(),
          child: const SignUpSreen(),
        ),
        settings: settings,
      );
    case DashboardScreen.routeName:
      return _pageBuilder(
        (_) => const DashboardScreen(),
        settings: settings,
      );
    case CourseDetailView.routeName:
      return _pageBuilder(
        (_) => CourseDetailView(
          course: settings.arguments! as Course,
        ),
        settings: settings,
      );
    case ForgotPassScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthenticationBloc>(),
          child: const ForgotPassScreen(),
        ),
        settings: settings,
      );
    case AddVideoView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<CourseCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<VideosCbCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<NotificationsCubit>(),
            ),
          ],
          child: const AddVideoView(),
        ),
        settings: settings,
      );
    case AddMaterialView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<CourseCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<MaterialCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<NotificationsCubit>(),
            ),
          ],
          child: const AddMaterialView(),
        ),
        settings: settings,
      );
    case AddExamView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<CourseCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<ExamCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<NotificationsCubit>(),
            ),
          ],
          child: const AddExamView(),
        ),
        settings: settings,
      );
    case CourseVideosView.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<VideosCbCubit>(),
          child: CourseVideosView(settings.arguments! as Course),
        ),
        settings: settings,
      );
    case VideoPlayerView.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<VideosCbCubit>(),
          child: VideoPlayerView(
            videoURL: settings.arguments! as String,
          ),
        ),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
