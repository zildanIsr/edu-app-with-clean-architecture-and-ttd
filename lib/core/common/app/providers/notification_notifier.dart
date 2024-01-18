import 'package:education_app/core/utils/constans.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsNotifier extends ChangeNotifier {
  NotificationsNotifier(this._prefs) {
    _muteNotifications = _prefs.getBool(notificationKey) ?? false;
  }

  final SharedPreferences _prefs;
  late bool _muteNotifications;

  bool get muteNotifications => _muteNotifications;

  void enableNotificationSounds() {
    _muteNotifications = false;
    _prefs.setBool(notificationKey, false);
    notifyListeners();
  }

  void disableNotificationSounds() {
    _muteNotifications = true;
    _prefs.setBool(notificationKey, true);
    notifyListeners();
  }

  void toggleMuteNotifications() {
    _muteNotifications = !_muteNotifications;
    _prefs.setBool(notificationKey, _muteNotifications);
    notifyListeners();
  }
}
