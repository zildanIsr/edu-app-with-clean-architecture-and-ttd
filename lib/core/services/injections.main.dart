part of 'injections.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _onBoardingInit();
  await _authInit();
  await _courseInit();
  await _videosInit();
}

Future<void> _videosInit() async {
  sl
    ..registerFactory(
      () => VideosCbCubit(
        addVideos: sl(),
        getVideos: sl(),
      ),
    )
    ..registerLazySingleton(() => AddVideos(sl()))
    ..registerLazySingleton(() => GetVideos(sl()))
    ..registerLazySingleton<VideoRepo>(() => VideoRepoImpl(sl()))
    ..registerLazySingleton<VideoRemoteDataSrc>(
      () => VideoRemoteDataSrcImpl(
        auth: sl(),
        firestore: sl(),
        storage: sl(),
      ),
    );
}

Future<void> _courseInit() async {
  sl
    ..registerFactory(
      () => CourseCubit(
        addCourse: sl(),
        getCourse: sl(),
      ),
    )
    ..registerLazySingleton(() => AddCourse(sl()))
    ..registerLazySingleton(() => GetCourse(sl()))
    ..registerLazySingleton<CourseRepo>(() => CourseRepoImpl(sl()))
    ..registerLazySingleton<CourseRemoteDataSrc>(
      () => CourseRemoteDataSrcImpl(
        firestore: sl(),
        storage: sl(),
        auth: sl(),
      ),
    );
}

Future<void> _authInit() async {
  sl
    ..registerFactory(
      () => AuthenticationBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSrcImpl(
        firebaseAuth: sl(),
        firestore: sl(),
        storage: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _onBoardingInit() async {
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
