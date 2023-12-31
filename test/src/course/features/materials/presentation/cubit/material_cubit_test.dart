import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/course/features/materials/data/models/resource_dto.dart';
import 'package:education_app/src/course/features/materials/domain/usecases/add_material.dart';
import 'package:education_app/src/course/features/materials/domain/usecases/get_materials.dart';
import 'package:education_app/src/course/features/materials/presentation/cubit/material_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddMaterial extends Mock implements AddMaterial {}

class MockGetMaterials extends Mock implements GetMaterials {}

void main() {
  late AddMaterial addMaterial;
  late GetMaterials getMaterials;
  late MaterialCubit materialCubit;

  final tMaterial = ResourceModel.empty();

  final tFailure = APIFailure(
    message: 'something went error',
    statusCode: '500',
  );

  setUp(() {
    addMaterial = MockAddMaterial();
    getMaterials = MockGetMaterials();
    materialCubit =
        MaterialCubit(addMaterial: addMaterial, getMaterials: getMaterials);

    registerFallbackValue(tMaterial);
  });

  tearDown(() {
    materialCubit.close();
  });

  test('initial state should be [MaterialInitial]', () async {
    expect(materialCubit.state, MaterialInitial());
  });

  group('addMaterial', () {
    blocTest<MaterialCubit, MaterialState>(
      'emits [AddingMaterials, MaterialsAdded] when addMaterial is added.',
      build: () {
        when(
          () => addMaterial(any()),
        ).thenAnswer((_) async => const Right(null));
        return materialCubit;
      },
      act: (cubit) => cubit.addMaterial([tMaterial]),
      expect: () => const <MaterialState>[AddingMaterial(), MaterialAdded()],
      verify: (_) {
        verify(() => addMaterial(tMaterial)).called(1);
        verifyNoMoreInteractions(addMaterial);
      },
    );

    blocTest<MaterialCubit, MaterialState>(
      'emits [AddingMaterials, MaterialError] when addMaterial is failed.',
      build: () {
        when(
          () => addMaterial(any()),
        ).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );
        return materialCubit;
      },
      act: (cubit) => cubit.addMaterial([tMaterial]),
      expect: () => <MaterialState>[
        const AddingMaterial(),
        MaterialError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => addMaterial(tMaterial)).called(1);
        verifyNoMoreInteractions(addMaterial);
      },
    );
  });

  group('getmaterials', () {
    blocTest<MaterialCubit, MaterialState>(
      'emits [LoadingMaterials, MaterialsLoaded] when getMaterial is added.',
      build: () {
        when(
          () => getMaterials(any()),
        ).thenAnswer((_) async => const Right([]));
        return materialCubit;
      },
      act: (cubit) => cubit.getMaterial(tMaterial.courseId),
      expect: () => const <MaterialState>[
        LoadingMaterials(),
        MaterialsLoaded(
          [],
        ),
      ],
      verify: (_) {
        verify(() => getMaterials(tMaterial.courseId)).called(1);
        verifyNoMoreInteractions(getMaterials);
      },
    );

    blocTest<MaterialCubit, MaterialState>(
      'emits [LoadingMaterials, MaterialError] when getMaterial is failed.',
      build: () {
        when(
          () => getMaterials(any()),
        ).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );
        return materialCubit;
      },
      act: (cubit) => cubit.getMaterial(tMaterial.courseId),
      expect: () => <MaterialState>[
        const LoadingMaterials(),
        MaterialError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getMaterials(tMaterial.courseId)).called(1);
        verifyNoMoreInteractions(getMaterials);
      },
    );
  });
}
