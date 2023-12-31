import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:education_app/src/course/features/materials/domain/repos/resource_repo.dart';
import 'package:education_app/src/course/features/materials/domain/usecases/add_material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_material_repo.dart';

void main() {
  late MaterialRepo repo;
  late AddMaterial usecase;

  final tMaterial = Resource.empty();

  setUp(() {
    repo = MockMaterialRepo();
    usecase = AddMaterial(repo);
    registerFallbackValue(tMaterial);
  });

  test('should call [MaterialRepo.addMaterial]', () async {
    when(() => repo.addMaterial(any())).thenAnswer(
      (_) async => const Right(null),
    );

    final result = await usecase(tMaterial);

    expect(result, isA<Right<dynamic, void>>());
    verify(
      () => repo.addMaterial(tMaterial),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
