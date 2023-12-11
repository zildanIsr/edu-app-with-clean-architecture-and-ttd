import 'package:bloc/bloc.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/add_videos.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:equatable/equatable.dart';

part 'videos_cb_state.dart';

class VideosCbCubit extends Cubit<VideosCbState> {
  VideosCbCubit({
    required AddVideos addVideos,
    required GetVideos getVideos,
  })  : _addVideos = addVideos,
        _getVideos = getVideos,
        super(VideosCbInitial());

  final AddVideos _addVideos;
  final GetVideos _getVideos;

  Future<void> addVideo(Video video) async {
    emit(const AddingVideo());
    final result = await _addVideos(video);

    result.fold(
      (failure) => emit(VideoError(failure.errorMessage)),
      (_) => emit(const VideoAdded()),
    );
  }

  Future<void> getVideos(String courseId) async {
    emit(const LoadingVideos());
    final result = await _getVideos(courseId);
    result.fold(
      (failure) => emit(VideoError(failure.errorMessage)),
      (videos) => emit(VideosLoaded(videos)),
    );
  }
}
