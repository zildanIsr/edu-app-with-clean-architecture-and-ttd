import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.numberOfExams,
    required super.numberOfMaterials,
    required super.numberOfVideos,
    required super.groupId,
    required super.createdAt,
    required super.updatedAt,
    super.description,
    super.image,
    super.imageIsFile = false,
  });

  // ---------------------------------------------------------------------------
  // JSON
  // ---------------------------------------------------------------------------
  factory CourseModel.fromRawJson(String str) =>
      CourseModel.fromMap(json.decode(str) as DataMap);

  CourseModel.empty()
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

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory CourseModel.fromMap(DataMap map) => CourseModel(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String?,
        groupId: map['groupId'] as String,
        numberOfExams: (map['numberOfExams'] as num).toInt(),
        numberOfMaterials: (map['numberOfMaterials'] as num).toInt(),
        numberOfVideos: (map['numberOfVideos'] as num).toInt(),
        image: map['image'] as String?,
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      );

  DataMap toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'groupId': groupId,
        'image': image,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'numberOfExams': numberOfExams,
        'numberOfMaterials': numberOfMaterials,
        'numberOfVideos': numberOfVideos,
      };

  String toRawJson() => json.encode(toMap());

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    bool? imageIsFile,
    num? numberOfExams,
    num? numberOfMaterials,
    num? numberOfVideos,
    String? groupId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      imageIsFile: imageIsFile ?? this.imageIsFile,
      numberOfExams: numberOfExams ?? this.numberOfExams,
      numberOfMaterials: numberOfMaterials ?? this.numberOfMaterials,
      numberOfVideos: numberOfVideos ?? this.numberOfVideos,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
