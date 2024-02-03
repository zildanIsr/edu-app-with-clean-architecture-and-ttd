import 'dart:math';

import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/common/widgets/pop_up_item.dart';
//import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/src/chat/domain/entities/chat_group.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({required this.group, super.key});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const NestedBackButton(),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(group.groupImageUrl!),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(
            width: 7,
          ),
          Text(group.name),
        ],
      ),
      foregroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.primaries[Random().nextInt(Colors.primaries.length)],
              Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ],
          ),
        ),
      ),
      actions: [
        PopupMenuButton(
          offset: const Offset(0, 50),
          surfaceTintColor: Colors.white,
          icon: const Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          itemBuilder: (_) => [
            PopupMenuItem<void>(
              child: const PopupItem(
                tittle: 'Leave group',
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
              ),
              onTap: () async {
                final chatCubit = context.read<ChatCubit>();
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog.adaptive(
                      title: const Text('Leave Group'),
                      content: const Text(
                        'Are you sure you want to leave the group',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Leave exam'),
                        ),
                      ],
                    );
                  },
                );
                if (result ?? false) {
                  await chatCubit.leaveGroup(
                    groupId: group.id,
                    userId: sl<FirebaseAuth>().currentUser!.uid,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
