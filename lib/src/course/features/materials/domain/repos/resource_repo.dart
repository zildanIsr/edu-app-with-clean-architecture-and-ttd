import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';

abstract class MaterialRepo {
  const MaterialRepo();

  ResultFuture<List<Resource>> getMaterials(String courseId);

  ResultFuture<void> addMaterial(Resource material);
}
