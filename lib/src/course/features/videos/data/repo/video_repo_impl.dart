import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/features/videos/data/datasources/video_remote_data_course.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repos/video_repos.dart';

class VideoRepoImpl implements VideoRepo {
  VideoRepoImpl(this._remoteDataSrc);

  final VideoRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<void> addVideo(Video video) async {
    try {
      await _remoteDataSrc.addVideo(video);
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Video>> getVideos(String courseId) async {
    try {
      final videos = await _remoteDataSrc.getVideos(courseId);
      return Right(videos);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
