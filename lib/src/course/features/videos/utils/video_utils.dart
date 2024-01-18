import 'package:education_app/core/extensions/string_extension.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/features/videos/data/models/video_dto.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/presentation/views/video_player_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_metadata/youtube.dart';

class VideoUtils {
  const VideoUtils._();

  static Future<Video?> getVideoFromYT(
    BuildContext context, {
    required String url,
  }) async {
    void showSnackBar(String message) =>
        CoreUtils.showSnackbar(context, message);
    try {
      final metadata = await YoutubeMetaData.getData(url);
      if (metadata.thumbnailUrl == null ||
          metadata.title == null ||
          metadata.authorName == null) {
        final missingData = <String>[];

        if (metadata.thumbnailUrl == null) missingData.add('Thubmnail');
        if (metadata.title == null) missingData.add('Title');
        if (metadata.authorName == null) missingData.add('Author Name');

        var missingDataToText = missingData
            .fold(
              '',
              (previousValue, element) => '$previousValue$element, ',
            )
            .trim();

        missingDataToText =
            missingDataToText.substring(0, missingDataToText.length - 1);

        final message = 'Could not get video data. Please try again.\n'
            'The following data is missing: $missingDataToText';

        showSnackBar(message);
        return null;
      }

      return VideoModel.empty().copyWith(
        thumbnail: metadata.thumbnailUrl,
        videoURL: url,
        title: metadata.title,
        tutor: metadata.authorName,
      );
    } catch (e) {
      showSnackBar('PLEASE TRY AGAIN\n$e');
      return null;
    }
  }

  static Future<void> playVideo(BuildContext context, String videoURL) async {
    final navigator = Navigator.of(context);
    if (videoURL.isYoutubeVideo) {
      if (!await launchUrl(
        Uri.parse(videoURL),
        mode: LaunchMode.externalApplication,
      )) {
        // ignore: use_build_context_synchronously
        CoreUtils.showSnackbar(context, 'Could not launch $videoURL');
      }
    } else {
      await navigator.pushNamed(
        VideoPlayerView.routeName,
        arguments: videoURL,
      );
    }
  }
}
