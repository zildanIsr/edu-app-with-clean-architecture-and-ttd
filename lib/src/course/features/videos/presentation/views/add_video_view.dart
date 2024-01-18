import 'package:education_app/core/common/widgets/course_picker.dart';
import 'package:education_app/core/common/widgets/info_field.dart';
import 'package:education_app/core/common/widgets/reactive_button.dart';
import 'package:education_app/core/common/widgets/video_tile.dart';
import 'package:education_app/core/enums/notification_enum.dart';
import 'package:education_app/core/extensions/string_extension.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/features/videos/data/models/video_dto.dart';
import 'package:education_app/src/course/features/videos/presentation/cubit/videos_cb_cubit.dart';
import 'package:education_app/src/course/features/videos/utils/video_utils.dart';
import 'package:education_app/src/notification/presentations/widgets/notification_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

class AddVideoView extends StatefulWidget {
  const AddVideoView({super.key});

  static const routeName = '/add-video';

  @override
  State<AddVideoView> createState() => _AddVideoViewState();
}

class _AddVideoViewState extends State<AddVideoView> {
  final urlController = TextEditingController();
  final authorController = TextEditingController(text: 'Admin');
  final titleController = TextEditingController();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  final formKey = GlobalKey<FormState>();

  VideoModel? video;
  PreviewData? previewData;

  final authorFocusNode = FocusNode();
  final titleFocusNode = FocusNode();
  final urlFocusNode = FocusNode();

  bool getMoreDetails = false;

  bool get isYoutube => urlController.text.trim().isYoutubeVideo;

  bool thumbNailIsFile = false;

  bool loading = false;

  bool showingDialog = false;

  void reset() {
    setState(() {
      urlController.clear();
      authorController.text = 'Admin';
      titleController.clear();
      getMoreDetails = false;
      loading = false;
      video = null;
      previewData = null;
    });
  }

  @override
  void initState() {
    super.initState();
    urlController.addListener(() {
      if (urlController.text.trim().isEmpty) reset();
    });
    authorController.addListener(() {
      video = video?.copyWith(tutor: authorController.text.trim());
    });
    titleController.addListener(() {
      video = video?.copyWith(title: titleController.text.trim());
    });
  }

  Future<void> fetchVideo() async {
    if (urlController.text.trim().isEmpty) return;

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      getMoreDetails = false;
      loading = false;
      thumbNailIsFile = false;
      video = null;
      previewData = null;
    });
    setState(() {
      loading = true;
    });
    if (isYoutube) {
      video = await VideoUtils.getVideoFromYT(
        context,
        url: urlController.text.trim(),
      ) as VideoModel?;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    authorController.dispose();
    titleController.dispose();
    courseController.dispose();
    courseNotifier.dispose();
    urlFocusNode.dispose();
    titleFocusNode.dispose();
    authorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onNotificationSent: () {
        Navigator.pop(context);
      },
      child: BlocListener<VideosCbCubit, VideosCbState>(
        listener: (context, state) {
          if (showingDialog == true) {
            Navigator.pop(context);
          }
          if (state is AddingVideo) {
            CoreUtils.showLoadingDialog(context);
            setState(() {
              showingDialog = true;
            });
          } else if (state is VideoError) {
            CoreUtils.showSnackbar(context, state.message);
          } else if (state is VideoAdded) {
            CoreUtils.showSnackbar(context, 'Video added successfully');
            CoreUtils.sendNotification(
              context,
              category: NotificationCategory.VIDEO,
              title: 'New ${courseNotifier.value!.title}',
              body: 'A new video has been added for '
                  '${courseNotifier.value!.title}',
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Video'),
          ),
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: [
              Form(
                key: formKey,
                child: CoursePicker(
                  controller: courseController,
                  notifier: courseNotifier,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //URL textfield
              InfoField(
                controller: urlController,
                hintText: 'Enter video URL',
                onEditingComplete: fetchVideo,
                focusNode: urlFocusNode,
                onTapOutSide: (_) => urlFocusNode.unfocus(),
                autoFocus: true,
                keyboardType: TextInputType.url,
              ),
              ListenableBuilder(
                listenable: urlController,
                builder: (_, __) {
                  return Column(
                    children: [
                      if (urlController.text.trim().isNotEmpty) ...[
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: fetchVideo,
                          child: const Text('Fetch'),
                        ),
                      ],
                    ],
                  );
                },
              ),
              if (loading && !isYoutube)
                LinkPreview(
                  enableAnimation: true,
                  onPreviewDataFetched: (data) async {
                    setState(() {
                      thumbNailIsFile = false;
                      video = VideoModel.empty().copyWith(
                        thumbnail: data.image?.url,
                        videoURL: urlController.text.trim(),
                        title: data.title ?? 'No title',
                      );
                      if (data.image?.url != null) loading = false;
                      getMoreDetails = true;
                      titleController.text = data.title ?? '';
                      loading = false;
                    });
                  },
                  previewData: previewData,
                  text: '',
                  width: 0,
                ),
              if (video != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: VideoTile(
                    video!,
                    isFile: thumbNailIsFile,
                  ),
                ),
              if (getMoreDetails) ...[
                InfoField(
                  controller: authorController,
                  keyboardType: TextInputType.name,
                  autoFocus: true,
                  focusNode: authorFocusNode,
                  labelText: 'Tutor Name',
                  onEditingComplete: () {
                    setState(() {});
                    titleFocusNode.requestFocus();
                  },
                ),
                InfoField(
                  controller: titleController,
                  labelText: 'Video Title',
                  focusNode: titleFocusNode,
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {});
                  },
                ),
              ],
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ReactiveButton(
                  isLoading: loading,
                  isDisabled: video == null,
                  text: 'Submit',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (courseNotifier.value == null) {
                        CoreUtils.showSnackbar(context, 'Please pick a course');
                        return;
                      }
                      if (courseNotifier.value != null &&
                          video != null &&
                          video!.tutor == null &&
                          authorController.text.trim().isNotEmpty) {
                        video = video!.copyWith(
                          tutor: authorController.text.trim(),
                        );
                      }
                      if (video != null &&
                          video!.tutor != null &&
                          video!.title != null &&
                          video!.title!.isNotEmpty) {
                        video = video?.copyWith(
                          thumbnailIsFile: thumbNailIsFile,
                          courseId: courseNotifier.value!.id,
                          uploadDate: DateTime.now(),
                        );
                        context.read<VideosCbCubit>().addVideo(video!);
                      } else {
                        CoreUtils.showSnackbar(
                          context,
                          'Please fill all fields',
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
