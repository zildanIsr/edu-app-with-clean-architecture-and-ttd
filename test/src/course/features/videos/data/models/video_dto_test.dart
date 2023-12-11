import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/course/features/videos/data/models/video_dto.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 1702200013688,
    '_nanoseconds': 270000000,
  };

  final date = DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds']!)
      .add(Duration(microseconds: timestampData['_nanoseconds']!));

  final timestamp = Timestamp.fromDate(date);

  final tVideo = VideoModel.empty();

  final tMap = jsonDecode(fixtures('video.json')) as DataMap;
  tMap['uploadDate'] = timestamp;

  test('should be a subclass of [Video] entity', () {
    expect(tVideo, isA<Video>());
  });

  group('fromMap', () {
    test('should return a [VideoModel] with the correct data', () {
      final result = VideoModel.fromMap(tMap);
      expect(result, equals(tVideo));
    });
  });

  group('toMap', () {
    test('should return a [Map] wih the proper data', () async {
      final result = tVideo.toMap()..remove('uploadDate');

      final map = DataMap.from(tMap)..remove('uploadDate');

      expect(result, equals(map));
    });
  });

  group('copyWith', () {
    test('should return a [VideoModel] with the new data', () {
      final result = tVideo.copyWith(
        tutor: 'New Tutor',
      );

      expect(result.tutor, 'New Tutor');
    });
  });

  // group('json', () {
  //   test('should return a [VideoModel] with the correct data', () async {
  //     //   final jsonMap = {
  //     //   'id': '_empty.id',
  //     //   'thumbnail': null,
  //     //   'videoURL': '_empty.videoURL',
  //     //   'title': null,
  //     //   'tutor': null,
  //     //   'courseId': '_empty.courseId',
  //     //   'thumbnailIsFile': false,
  //     //   'uploadDate' : DateTime.now()
  //     // };
  //     final json = jsonEncode(tMap);
  //     final result = VideoModel.fromJson(json);
  //     final testMap = jsonDecode(fixtures('video.json')) as DataMap;
  //     expect(result, testMap);
  //   });

  //   test('should return a [JSON] type', () async {
  //     final result = tVideo.toJson();
  //     final json = jsonEncode(tMap);
  //     expect(result, json);
  //   });
  // });
}
