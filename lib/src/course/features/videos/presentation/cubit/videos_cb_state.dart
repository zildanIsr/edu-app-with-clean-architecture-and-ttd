part of 'videos_cb_cubit.dart';

sealed class VideosCbState extends Equatable {
  const VideosCbState();

  @override
  List<Object> get props => [];
}

final class VideosCbInitial extends VideosCbState {}

class VideoAdded extends VideosCbState {
  const VideoAdded();
}

class AddingVideo extends VideosCbState {
  const AddingVideo();
}

class LoadingVideos extends VideosCbState {
  const LoadingVideos();
}

class VideosLoaded extends VideosCbState {
  const VideosLoaded(this.videos);

  final List<Video> videos;

  @override
  List<Object> get props => [videos];
}

class VideoError extends VideosCbState {
  const VideoError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
