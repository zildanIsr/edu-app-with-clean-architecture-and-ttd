import 'dart:convert';

import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = UserModel.empty();
  final tJson = fixtures('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  test(
    'should be a subclass of [LocalUser] entity',
    () => expect(tLocalUserModel, isA<LocalUser>()),
  );

  group('from Map', () {
    test('should return a [UserModel] with the right data', () async {
      final result = UserModel.fromMap(tMap);

      expect(result, equals(tLocalUserModel));
    });

    test('should return an [Error] when the map is invalid', () async {
      final map = DataMap.from(tMap)..remove('uid');

      const call = UserModel.fromMap;

      expect(() => call(map), throwsA(isA<Error>()));
    });
  });

  group('form JSON testing', () {
    test('should return a [MAP] with the right data', () {
      //Act
      final result = userModelFromJson(tJson);

      expect(result, equals(tLocalUserModel));
    });
  });

  group('to Map', () {
    test('should return a [UserModel] with the right data', () {
      //Act
      final result = tLocalUserModel.toMap();
      //Assert
      expect(result, equals(tMap));
    });
  });

  group('to JSON', () {
    test('should return a [JSON] string with the right data', () {
      //Act
      final result = tLocalUserModel.toMap();

      // final tjson = jsonEncode({
      //   "id": 1,
      //   "name": "_empty.name",
      //   "avatar": "_empty.avatar",
      //   "createdAt": "_empty.createdAt"
      // });
      //Assert
      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('should return a new data', () {
      //Act
      final result = tLocalUserModel.copyWith(fullName: 'zildan');
      //Assert
      expect(result.fullName, equals('zildan'));
    });
  });
}
