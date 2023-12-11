import 'package:education_app/core/errors/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataSourceUtils {
  const DataSourceUtils._();

  static Future<void> authorizeUser(FirebaseAuth auth) async {
    final user = auth.currentUser;
    if (user == null) {
      throw APIException(
        message: 'User is not authentication',
        statusCode: '401',
      );
    }
  }
}
