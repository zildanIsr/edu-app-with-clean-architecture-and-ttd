import 'dart:io';

String fixtures(String fileName) =>
    File('test/fixtures/$fileName').readAsStringSync();
