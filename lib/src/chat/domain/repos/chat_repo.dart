import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/authentication/domain/entities/user.dart';
import 'package:education_app/src/chat/domain/entities/chat_group.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';

abstract class ChatRepo {
  const ChatRepo();

  ResultFuture<void> sendMessage(Message message);

  ResultStream<List<Group>> getGroups();

  ResultStream<List<Message>> getMessages(String groupId);

  ResultFuture<void> joinGroup({
    required String groupId,
    required String userId,
  });

  ResultFuture<void> leaveGroup({
    required String groupId,
    required String userId,
  });

  ResultFuture<LocalUser> getUserById(String userId);
}
