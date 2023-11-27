part of 'injections.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _onBoardingInit();
  await _authInit();
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