import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_board_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences preferences;
  late OnBoardLocalDataSource localDataSource;

  setUp(() {
    preferences = MockSharedPreferences();
    localDataSource = OnBoardLocalDataSrImpl(preferences);
  });

  group('Chace first time', () {
    test('should call [SharedPreference] to chache the data', () async {
      when(() => preferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      await localDataSource.cacheFirstTime();

      verify(
        () => preferences.setBool(kFirstTimeKey, false),
      ).called(1);
      verifyNoMoreInteractions(preferences);
    });

    test(
        'should throw [CacheException] when there is an Error '
        'caching the data', () async {
      when(() => preferences.setBool(any(), any())).thenThrow(Exception());

      final methodCall = localDataSource.cacheFirstTime();

      expect(methodCall, throwsA(isA<CacheException>()));

      verify(
        () => preferences.setBool(kFirstTimeKey, false),
      ).called(1);
      verifyNoMoreInteractions(preferences);
    });
  });

  group('checkIfUserIsFirstTime', () {
    test(
        'should call [sharedPreference] to check if user is first time '
        'and return the right response from storage if data exists', () async {
      when(
        () => preferences.getBool(any()),
      ).thenReturn(false);

      final result = await localDataSource.checkIfUserIsFirstTime();

      expect(result, false);

      verify(
        () => preferences.getBool(kFirstTimeKey),
      );

      verifyNoMoreInteractions(preferences);
    });

    test('should return true if there is no data in storage', () async {
      when(
        () => preferences.getBool(any()),
      ).thenReturn(null);

      final result = await localDataSource.checkIfUserIsFirstTime();

      expect(result, true);

      verify(
        () => preferences.getBool(kFirstTimeKey),
      );

      verifyNoMoreInteractions(preferences);
    });

    test(
        'should throw a [CacheException] when there is an Error '
        'retrieving the data', () async {
      when(
        () => preferences.getBool(any()),
      ).thenThrow(Exception());

      final call = localDataSource.checkIfUserIsFirstTime;

      expect(call, throwsA(isA<CacheException>()));

      verify(
        () => preferences.getBool(kFirstTimeKey),
      ).called(1);

      verifyNoMoreInteractions(preferences);
    });
  });
}
