import 'package:education_app/core/extensions/int_extenstion.dart';

extension DatetimeExt on DateTime {
  String get timeAgo {
    final nowUtc = DateTime.now().toUtc();

    final diff = nowUtc.difference(toUtc());

    if (diff.inDays > 365) {
      final year = (diff.inDays / 365).floor();
      return '$year year${year.pluralize} ago';
    } else if (diff.inDays > 30) {
      final month = (diff.inDays / 30).floor();
      return '$month month${month.pluralize} ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays.pluralize} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours.pluralize} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes.pluralize} ago';
    } else {
      return 'now';
    }
  }
}
