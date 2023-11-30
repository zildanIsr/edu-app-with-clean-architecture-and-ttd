import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/services/injections.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardUtils {
  const DashboardUtils._();

  static Stream<UserModel> get userDataStream => sl<FirebaseFirestore>()
      .collection('users')
      .doc(sl<FirebaseAuth>().currentUser!.uid)
      .snapshots()
      .map((event) => UserModel.fromMap(event.data()!));
}
