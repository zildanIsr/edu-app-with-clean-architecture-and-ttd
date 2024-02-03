import 'package:education_app/core/common/views/loading.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/chat/domain/entities/chat_group.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:education_app/src/chat/presentation/widgets/list_group_tile.dart';
import 'package:education_app/src/chat/presentation/widgets/your_group_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupChatView extends StatefulWidget {
  const GroupChatView({super.key});

  @override
  State<GroupChatView> createState() => _GroupChatViewState();
}

class _GroupChatViewState extends State<GroupChatView> {
  List<Group> yourGroup = [];
  List<Group> listGroup = [];

  bool showingDialog = false;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chat Group'),
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (_, state) {
          if (showingDialog) {
            Navigator.pop(context);
            showingDialog = false;
          }
          if (state is ChatError) {
            CoreUtils.showSnackbar(context, state.message);
          } else if (state is JoiningGroup) {
            CoreUtils.showLoadingDialog(context);
            showingDialog = true;
          } else if (state is JoinedGroup) {
            CoreUtils.showSnackbar(context, 'Joined group successfully');
          } else if (state is GroupsLoaded) {
            yourGroup = state.groups
                .where(
                  (group) => group.members.contains(context.currentUser!.uid),
                )
                .toList();
            listGroup = state.groups
                .where(
                  (group) => !group.members.contains(context.currentUser!.uid),
                )
                .toList();
          }
        },
        builder: (context, state) {
          if (state is LoadingGroups) {
            return const LoadingView();
          } else if (state is GroupsLoaded && state.groups.isEmpty) {
            return const NotFoundText(
              text: 'No groups found\nPlease contact admin to add new courses',
            );
          } else if ((state is GroupsLoaded) ||
              (yourGroup.isNotEmpty) ||
              (listGroup.isNotEmpty)) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (yourGroup.isNotEmpty) ...[
                  Text(
                    'Your Groups',
                    style: context.theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  ...yourGroup.map(YourGroupTile.new),
                ],
                if (listGroup.isNotEmpty) ...[
                  Text(
                    'Groups',
                    style: context.theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  ...listGroup.map(ListGroupTile.new),
                ],
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
