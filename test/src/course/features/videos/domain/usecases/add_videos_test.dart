import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repos/video_repos.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/add_videos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_video_repo.dart';

void main() {
  late VideoRepo repo;
  late AddVideos usecase;

  final tVideos = Video.empty();
  setUp(() {
    repo = MockVideoRepo();
    usecase = AddVideos(repo);
    registerFallbackValue(tVideos);
  });

  test('should call [VideoRepo.addVideo]', () async {
    when(() => repo.addVideo(any())).thenAnswer(
      (_) async => const Right(null),
    );

    final result = await usecase(tVideos);

    expect(result, isA<Right<dynamic, void>>());
    verify(
      () => repo.addVideo(tVideos),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
