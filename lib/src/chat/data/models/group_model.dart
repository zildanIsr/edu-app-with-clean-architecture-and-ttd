import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/chat/domain/entities/chat_group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    required super.courseId,
    required super.members,
    super.lastMessage,
    super.groupImageUrl,
    super.lastMessageTimestamp,
    super.lastMessageSenderName,
  });

  GroupModel.emty()
      : this(
          id: '_empty.id',
          name: '_empty.name',
          courseId: '_empty.courseId',
          members: [],
          lastMessage: null,
          groupImageUrl: null,
          lastMessageTimestamp: null,
          lastMessageSenderName: null,
        );

  factory GroupModel.fromMap(DataMap map) => GroupModel(
        id: map['id'] as String,
        name: map['name'] as String,
        courseId: map['courseId'] as String,
        members: List<String>.from(map['members'] as List<dynamic>),
        lastMessage: map['lastMessage'] as String?,
        groupImageUrl: map['groupImageUrl'] as String?,
        lastMessageTimestamp:
            (map['lastMessageTimestamp'] as Timestamp?)?.toDate(),
        lastMessageSenderName: map['lastMessageSenderName'] as String?,
      );

  Group copyWith({
    String? id,
    String? name,
    String? courseId,
    List<String>? members,
    String? lastMessage,
    String? groupImageUrl,
    DateTime? lastMessageTimestamp,
    String? lastMessageSenderName,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      courseId: courseId ?? this.courseId,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      groupImageUrl: groupImageUrl ?? this.groupImageUrl,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      lastMessageSenderName:
          lastMessageSenderName ?? this.lastMessageSenderName,
    );
  }

  DataMap toMap() => {
        'id': id,
        'courseId': courseId,
        'name': name,
        'members': members,
        'lastMessage': lastMessage,
        'lastMessageSenderName': lastMessageSenderName,
        'lastMessageTimestamp':
            lastMessage == null ? null : FieldValue.serverTimestamp(),
        'groupImageUrl': groupImageUrl,
      };
}
