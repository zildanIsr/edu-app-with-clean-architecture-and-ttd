import 'package:education_app/core/errors/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardLocalDataSource {
  const OnBoardLocalDataSource();

  Future<void> cacheFirstTime();
  Future<bool> checkIfUserIsFirstTime();
}

const kFirstTimeKey = 'first_time';

class OnBoardLocalDataSrImpl extends OnBoardLocalDataSource {
  const OnBoardLocalDataSrImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> cacheFirstTime() async {
    try {
      await _prefs.setBool(kFirstTimeKey, false);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<bool> checkIfUserIsFirstTime() async {
    try {
      return _prefs.getBool(kFirstTimeKey) ?? true;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
