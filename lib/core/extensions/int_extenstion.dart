extension IntExt on int {
  String get pluralize {
    return this > 1 ? 's' : '';
  }
}
