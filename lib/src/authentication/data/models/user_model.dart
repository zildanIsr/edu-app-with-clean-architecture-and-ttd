import 'dart:convert';

import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/authentication/domain/entities/user.dart';

UserModel userModelFromJson(String str) =>
    UserModel.fromMap(json.decode(str) as DataMap);

String userModelToJson(UserModel data) => json.encode(data.toMap());

class UserModel extends LocalUser {
  const UserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    super.groupIds,
    super.enrolledCourseIds,
    super.followings,
    super.followers,
    super.profilePic,
    super.bio,
  });

  const UserModel.empty()
      : this(
          uid: 'uid',
          email: 'email',
          points: 0,
          fullName: 'fullName',
        );

  factory UserModel.fromMap(DataMap json) => UserModel(
        uid: json['uid'] as String,
        email: json['email'] as String,
        profilePic: json['profilePic'] as String?,
        bio: json['bio'] as String?,
        points: (json['points'] as num).toInt(),
        fullName: json['fullName'] as String,
        groupIds: List<String>.from(
          (json['groupIds'] as Iterable).map((x) => x as String),
        ),
        enrolledCourseIds: List<String>.from(
          (json['enrolledCourseIds'] as Iterable).map((x) => x as String),
        ),
        followings: List<String>.from(
          (json['followings'] as Iterable).map((x) => x as String),
        ),
        followers: List<String>.from(
          (json['followers'] as Iterable).map((x) => x as String),
        ),
      );

  UserModel copyWith({
    String? uid,
    String? email,
    String? profilePic,
    String? bio,
    int? points,
    String? fullName,
    List<String>? groupIds,
    List<String>? enrolledCourseIds,
    List<String>? followings,
    List<String>? followers,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        profilePic: profilePic ?? this.profilePic,
        bio: bio ?? this.bio,
        points: points ?? this.points,
        fullName: fullName ?? this.fullName,
        groupIds: groupIds ?? this.groupIds,
        enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
        followings: followings ?? this.followings,
        followers: followers ?? this.followers,
      );

  DataMap toMap() => {
        'uid': uid,
        'email': email,
        'profilePic': profilePic,
        'bio': bio,
        'points': points,
        'fullName': fullName,
        'groupIds': List<dynamic>.from(groupIds.map((x) => x)),
        'enrolledCourseIds':
            List<dynamic>.from(enrolledCourseIds.map((x) => x)),
        'followings': List<dynamic>.from(followings.map((x) => x)),
        'followers': List<dynamic>.from(followers.map((x) => x)),
      };
}
