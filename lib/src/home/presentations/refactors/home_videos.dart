import 'package:education_app/core/common/views/loading.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/common/widgets/video_tile.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/features/videos/presentation/cubit/videos_cb_cubit.dart';
import 'package:education_app/src/home/presentations/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeVideos extends StatefulWidget {
  const HomeVideos({super.key});

  @override
  State<HomeVideos> createState() => _HomeVideosState();
}

class _HomeVideosState extends State<HomeVideos> {
  void getVideos() {
    context.read<VideosCbCubit>().getVideos(context.courseOfTheDay!.id);
  }

  @override
  void initState() {
    getVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideosCbCubit, VideosCbState>(
      listener: (context, state) {
        if (state is VideoError) {
          CoreUtils.showSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is LoadingVideos) {
          return const LoadingView();
        } else if ((state is VideosLoaded && state.videos.isEmpty) ||
            state is VideoError) {
          return NotFoundText(
            text: 'No videos found for ${context.courseOfTheDay!.title}',
          );
        } else if (state is VideosLoaded) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                sectionTitle: '${context.courseOfTheDay!.title} Videos',
                seeAll: state.videos.length > 4,
                onSeeAll: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              for (final video in state.videos.take(5))
                VideoTile(
                  video,
                  tappable: true,
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
