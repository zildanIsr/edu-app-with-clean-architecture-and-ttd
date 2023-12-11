import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repos/video_repos.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_video_repo.dart';

void main() {
  late VideoRepo repo;
  late GetVideos usecase;

  final tVideos = Video.empty();
  setUp(() {
    repo = MockVideoRepo();
    usecase = GetVideos(repo);
    //registerFallbackValue(tVideos);
  });

  test('should call [VideoRepo.getVideos]', () async {
    when(
      () => repo.getVideos(any()),
    ).thenAnswer(
      (_) async => Right([tVideos]),
    );

    final result = await usecase('courseId');

    expect(result, isA<Right<dynamic, List<Video>>>());
    verify(
      () => repo.getVideos('courseId'),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
