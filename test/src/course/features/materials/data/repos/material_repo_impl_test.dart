import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/course/features/materials/data/datasources/material_remote_data_source.dart';
import 'package:education_app/src/course/features/materials/data/models/resource_dto.dart';
import 'package:education_app/src/course/features/materials/data/repos/material_repo_impl.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMaterialRemoteDataSrc extends Mock implements MaterialRemoteDataSrc {}

void main() {
  late MaterialRemoteDataSrc remoteDataSrc;
  late MaterialRepoImpl repo;

  final tMaterial = ResourceModel.empty();

  setUp(() {
    remoteDataSrc = MockMaterialRemoteDataSrc();
    repo = MaterialRepoImpl(remoteDataSrc);
    registerFallbackValue(tMaterial);
  });

  final tException = APIException(
    message: 'message',
    statusCode: 'statusCode',
  );

  group('Add Video', () {
    test(
        'should complete successfully when call to remote course is successful',
        () async {
      when(
        () => remoteDataSrc.addMaterial(any()),
      ).thenAnswer((_) async => Future.value());

      final result = await repo.addMaterial(tMaterial);

      expect(result, const Right<dynamic, void>(null));

      verify(
        () => remoteDataSrc.addMaterial(tMaterial),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test('should return exception when call to remote source is unsuccesful',
        () async {
      when(
        () => remoteDataSrc.addMaterial(any()),
      ).thenThrow(tException);

      final result = await repo.addMaterial(tMaterial);

      expect(
        result,
        equals(
          Left<APIFailure, dynamic>(
            APIFailure.fromException(tException),
          ),
        ),
      );
      verify(
        () => remoteDataSrc.addMaterial(tMaterial),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });

  group('getMaterials', () {
    test('should return List Resource when call to remote course is successful',
        () async {
      when(
        () => remoteDataSrc.getMaterials(any()),
      ).thenAnswer((_) async => []);

      final result = await repo.getMaterials(tMaterial.courseId);

      expect(result, isA<Right<dynamic, List<Resource>>>());

      verify(
        () => remoteDataSrc.getMaterials(tMaterial.courseId),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test('should return exception when call to remote source is unsuccesful',
        () async {
      when(
        () => remoteDataSrc.getMaterials(any()),
      ).thenThrow(tException);

      final result = await repo.getMaterials(tMaterial.courseId);

      expect(
        result,
        equals(
          Left<APIFailure, dynamic>(
            APIFailure.fromException(tException),
          ),
        ),
      );
      verify(
        () => remoteDataSrc.getMaterials(tMaterial.courseId),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });
}
