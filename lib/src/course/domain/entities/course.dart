// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.numberOfExams,
    required this.numberOfMaterials,
    required this.numberOfVideos,
    required this.groupId,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.image,
    this.imageIsFile = false,
  });

  Course.empty()
      : this(
          id: '_empty.id',
          title: '_empty.title',
          description: '_empty.description',
          numberOfExams: 0,
          numberOfMaterials: 0,
          numberOfVideos: 0,
          groupId: '_empty.groupId',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

  final String id;
  final String title;
  final String? description;
  final String? image;
  final bool imageIsFile;
  final num numberOfExams;
  final num numberOfMaterials;
  final num numberOfVideos;
  final String groupId;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        image,
        imageIsFile,
        numberOfExams,
        numberOfMaterials,
        numberOfVideos,
        groupId,
      ];

  @override
  bool get stringify => true;
}
