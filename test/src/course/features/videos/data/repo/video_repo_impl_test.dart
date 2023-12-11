import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/course/features/videos/data/datasources/video_remote_data_course.dart';
import 'package:education_app/src/course/features/videos/data/models/video_dto.dart';
import 'package:education_app/src/course/features/videos/data/repo/video_repo_impl.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVideosRemoteDataSrc extends Mock implements VideoRemoteDataSrc {}

void main() {
  late VideoRemoteDataSrc remoteDataSrc;
  late VideoRepoImpl repoImpl;

  final tVideo = VideoModel.empty();

  setUp(() {
    remoteDataSrc = MockVideosRemoteDataSrc();
    repoImpl = VideoRepoImpl(remoteDataSrc);
    registerFallbackValue(tVideo);
  });

  final tException = APIException(
    message: 'message',
    statusCode: 'statusCode',
  );

  group('addVideo', () {
    test(
        'should complete successfully when call to remote course is successful',
        () async {
      when(
        () => remoteDataSrc.addVideo(any()),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      final result = await repoImpl.addVideo(tVideo);

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => remoteDataSrc.addVideo(tVideo),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test('should throw an Exception when call to remote course is unsuccessful',
        () async {
      when(
        () => remoteDataSrc.addVideo(any()),
      ).thenThrow(tException);

      final result = await repoImpl.addVideo(tVideo);

      expect(
        result,
        equals(
          Left<APIFailure, dynamic>(
            APIFailure.fromException(tException),
          ),
        ),
      );
      verify(
        () => remoteDataSrc.addVideo(tVideo),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });

  group('getVideos', () {
    test('should return a List<Video> when call to remote course is successful',
        () async {
      when(
        () => remoteDataSrc.getVideos(any()),
      ).thenAnswer((_) async => [tVideo]);

      final result = await repoImpl.getVideos('courseId');

      expect(result, isA<Right<dynamic, List<Video>>>());
      verify(
        () => remoteDataSrc.getVideos('courseId'),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test('should throw an Exception when call to remote course is unsuccessful',
        () async {
      when(
        () => remoteDataSrc.getVideos(any()),
      ).thenThrow(tException);

      final result = await repoImpl.getVideos('courseId');

      expect(
        result,
        equals(
          Left<APIFailure, dynamic>(
            APIFailure.fromException(tException),
          ),
        ),
      );
      verify(
        () => remoteDataSrc.getVideos('courseId'),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });
}
