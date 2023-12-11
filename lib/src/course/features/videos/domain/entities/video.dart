import 'package:equatable/equatable.dart';

class Video extends Equatable {
  const Video({
    required this.id,
    required this.videoURL,
    required this.courseId,
    required this.uploadDate,
    this.thumbnail,
    this.title,
    this.tutor,
    this.thumbnailIsFile = false,
  });

  Video.empty()
      : this(
          id: '_empty.id',
          videoURL: '_empty.videoURL',
          uploadDate: DateTime.now(),
          courseId: '_empty.courseId',
        );

  final String id;
  final String? thumbnail;
  final String videoURL;
  final String? title;
  final String? tutor;
  final String courseId;
  final DateTime uploadDate;
  final bool thumbnailIsFile;

  @override
  List<Object?> get props {
    return [
      id,
      thumbnail,
      videoURL,
      title,
      tutor,
      courseId,
      uploadDate,
      thumbnailIsFile,
    ];
  }

  @override
  bool get stringify => true;
}
