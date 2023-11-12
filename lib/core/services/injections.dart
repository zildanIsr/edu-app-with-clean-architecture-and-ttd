import 'package:education_app/src/on_boarding/data/datasources/on_board_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repository/on_board_repo_impl.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/chace_first_time.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cb_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerFactory(
      () => OnBoardingCbCubit(
        cacheFirstTime: sl(),
        checkIfUserIsFirstTime: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTime(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTime(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardRepoImpl(sl()))
    ..registerLazySingleton<OnBoardLocalDataSource>(
      () => OnBoardLocalDataSrImpl(sl()),
    )
    ..registerLazySingleton(() => prefs);
}
