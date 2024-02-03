import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/src/chat/domain/entities/chat_group.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListGroupTile extends StatelessWidget {
  const ListGroupTile(this.group, {super.key});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(group.name),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(360),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.network(group.groupImageUrl!),
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          context
              .read<ChatCubit>()
              .joinGroup(groupId: group.id, userId: context.currentUser!.uid);
        },
        child: const Text('Join'),
      ),
    );
  }
}
