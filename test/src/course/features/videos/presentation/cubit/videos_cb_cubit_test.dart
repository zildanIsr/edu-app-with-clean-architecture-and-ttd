import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/course/features/videos/data/models/video_dto.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/add_videos.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:education_app/src/course/features/videos/presentation/cubit/videos_cb_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddVideo extends Mock implements AddVideos {}

class MockGetVideo extends Mock implements GetVideos {}

void main() {
  late AddVideos addVideo;
  late GetVideos getVideos;
  late VideosCbCubit videoCubit;

  final tVideo = VideoModel.empty();

  final tFailure = APIFailure(
    message: 'something went error',
    statusCode: '500',
  );

  setUp(() {
    addVideo = MockAddVideo();
    getVideos = MockGetVideo();
    videoCubit = VideosCbCubit(
      addVideos: addVideo,
      getVideos: getVideos,
    );

    registerFallbackValue(tVideo);
  });

  tearDown(() => videoCubit.close());

  test('initial state should be [VideoInitial]', () async {
    expect(videoCubit.state, VideosCbInitial());
  });

  group('add video', () {
    blocTest<VideosCbCubit, VideosCbState>(
      'emits [AddingVideo, VideoAdded] when addVideo is added.',
      build: () {
        when(
          () => addVideo(any()),
        ).thenAnswer((_) async => const Right(null));
        return videoCubit;
      },
      act: (cubit) => cubit.addVideo(tVideo),
      expect: () => const <VideosCbState>[AddingVideo(), VideoAdded()],
      verify: (_) {
        verify(
          () => addVideo(tVideo),
        ).called(1);
        verifyNoMoreInteractions(addVideo);
      },
    );

    blocTest<VideosCbCubit, VideosCbState>(
      'emits [AddingVideo, VideoError] when addVideo is added and fails.',
      build: () {
        when(
          () => addVideo(any()),
        ).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );
        return videoCubit;
      },
      act: (cubit) => cubit.addVideo(tVideo),
      expect: () => <VideosCbState>[
        const AddingVideo(),
        VideoError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => addVideo(tVideo),
        ).called(1);
        verifyNoMoreInteractions(addVideo);
      },
    );
  });

  group('get video', () {
    blocTest<VideosCbCubit, VideosCbState>(
      'emits [LoadingVideos, VideosLoaded] when getVideos is added.',
      build: () {
        when(
          () => getVideos(any()),
        ).thenAnswer((_) async => const Right([]));
        return videoCubit;
      },
      act: (cubit) => cubit.getVideos(tVideo.courseId),
      expect: () => const <VideosCbState>[LoadingVideos(), VideosLoaded([])],
      verify: (_) {
        verify(
          () => getVideos(tVideo.courseId),
        ).called(1);
        verifyNoMoreInteractions(getVideos);
      },
    );

    blocTest<VideosCbCubit, VideosCbState>(
      'emits [LoadingVideos, VideoError] when getVideos is added and fails.',
      build: () {
        when(
          () => getVideos(any()),
        ).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );
        return videoCubit;
      },
      act: (cubit) => cubit.getVideos(tVideo.courseId),
      expect: () => <VideosCbState>[
        const LoadingVideos(),
        VideoError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => getVideos(tVideo.courseId),
        ).called(1);
        verifyNoMoreInteractions(getVideos);
      },
    );
  });
}
