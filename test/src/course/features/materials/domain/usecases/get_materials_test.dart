import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:education_app/src/course/features/materials/domain/repos/resource_repo.dart';
import 'package:education_app/src/course/features/materials/domain/usecases/get_materials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_material_repo.dart';

void main() {
  late MaterialRepo repo;
  late GetMaterials usecase;

  final tMaterial = Resource.empty();

  setUp(() {
    repo = MockMaterialRepo();
    usecase = GetMaterials(repo);
    registerFallbackValue(tMaterial);
  });

  test('should call [MaterialRepo.getMaterial] when', () async {
    when(
      () => repo.getMaterials(any()),
    ).thenAnswer((_) async => const Right([]));

    final result = await usecase(tMaterial.courseId);

    expect(result, isA<Right<dynamic, List<Resource>>>());
    verify(
      () => repo.getMaterials(tMaterial.courseId),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
