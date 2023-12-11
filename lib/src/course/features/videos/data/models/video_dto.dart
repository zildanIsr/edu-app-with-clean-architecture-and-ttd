import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.videoURL,
    required super.courseId,
    required super.uploadDate,
    super.thumbnailIsFile = false,
    super.tutor,
    super.thumbnail,
    super.title,
  });

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] as String,
      thumbnail: map['thumbnail'] != null ? map['thumbnail'] as String : null,
      videoURL: map['videoURL'] as String,
      title: map['title'] != null ? map['title'] as String : null,
      tutor: map['tutor'] != null ? map['tutor'] as String : null,
      courseId: map['courseId'] as String,
      uploadDate: (map['uploadDate'] as Timestamp).toDate(),
    );
  }

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  VideoModel.empty()
      : this(
          id: '_empty.id',
          videoURL: '_empty.videoURL',
          uploadDate: DateTime.now(),
          courseId: '_empty.courseId',
        );

  VideoModel copyWith({
    String? id,
    String? thumbnail,
    String? videoURL,
    String? title,
    String? tutor,
    String? courseId,
    DateTime? uploadDate,
    bool? thumbnailIsFile,
  }) {
    return VideoModel(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      videoURL: videoURL ?? this.videoURL,
      title: title ?? this.title,
      tutor: tutor ?? this.tutor,
      courseId: courseId ?? this.courseId,
      uploadDate: uploadDate ?? this.uploadDate,
      thumbnailIsFile: thumbnailIsFile ?? this.thumbnailIsFile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'thumbnail': thumbnail,
      'videoURL': videoURL,
      'title': title,
      'tutor': tutor,
      'courseId': courseId,
      'uploadDate': FieldValue.serverTimestamp(),
    };
  }

  String toJson() => json.encode(toMap());
}
