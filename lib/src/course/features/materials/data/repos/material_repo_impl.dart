import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/features/materials/data/datasources/material_remote_data_source.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:education_app/src/course/features/materials/domain/repos/resource_repo.dart';

class MaterialRepoImpl extends MaterialRepo {
  const MaterialRepoImpl(this._dataSrc);

  final MaterialRemoteDataSrc _dataSrc;

  @override
  ResultFuture<void> addMaterial(Resource material) async {
    try {
      await _dataSrc.addMaterial(material);
      return const Right(null);
    } on APIException catch (e) {
      return left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Resource>> getMaterials(String courseId) async {
    try {
      final result = await _dataSrc.getMaterials(courseId);
      return Right(result);
    } on APIException catch (e) {
      return left(APIFailure.fromException(e));
    }
  }
}
