import 'package:education_app/core/common/views/loading.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/chat/domain/entities/chat_group.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:education_app/src/chat/presentation/refactors/chat_app_bar.dart';
import 'package:education_app/src/chat/presentation/widgets/chat_input_field.dart';
import 'package:education_app/src/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.group, super.key});

  final Group group;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool _showingDialog = false;

  bool _showInputField = false;

  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getMessages(widget.group.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(group: widget.group),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (_, state) {
          if (_showingDialog) {
            Navigator.pop(context);
            _showingDialog = false;
          }
          if (state is ChatError) {
            CoreUtils.showSnackbar(context, state.message);
          } else if (state is LeavingGroup) {
            CoreUtils.showLoadingDialog(context);
            _showingDialog = true;
          } else if (state is LeftGroup) {
            context.pop();
          } else if (state is MessagesLoaded) {
            setState(() {
              messages = state.messages;
              _showInputField = true;
            });
          }
        },
        builder: (context, state) {
          if (state is LoadingMessages) {
            return const LoadingView();
          } else if (state is MessagesLoaded ||
              _showInputField ||
              messages.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (_, int index) {
                      final message = messages[index];
                      final previousMessage =
                          index > 0 ? messages[index - 1] : null;

                      final showSenderInfo = previousMessage == null ||
                          previousMessage.senderId != message.senderId;
                      return BlocProvider(
                        create: (_) => sl<ChatCubit>(),
                        child: MessageBubble(
                          message: message,
                          showSenderInfo: showSenderInfo,
                        ),
                      );
                    },
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                BlocProvider(
                  create: (_) => sl<ChatCubit>(),
                  child: ChatInputField(groupId: widget.group.id),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
