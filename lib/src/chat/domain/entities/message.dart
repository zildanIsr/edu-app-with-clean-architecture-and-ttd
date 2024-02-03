import 'package:equatable/equatable.dart';

class Message extends Equatable {
  const Message({
    required this.id,
    required this.senderId,
    required this.message,
    required this.groupId,
    required this.timestamp,
  });

  Message.empty()
      : id = '',
        senderId = '',
        message = '',
        groupId = '',
        timestamp = DateTime.now();

  final String id;
  final String senderId;
  final String message;
  final String groupId;
  final DateTime timestamp;

  @override
  List<Object?> get props => [id, groupId];

  @override
  bool get stringify => true;
}
