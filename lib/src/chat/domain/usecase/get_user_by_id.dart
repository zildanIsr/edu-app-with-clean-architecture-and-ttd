import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/authentication/domain/entities/user.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';

class GetUserById extends UsecaseWithParams<LocalUser, String> {
  const GetUserById(this._repo);

  final ChatRepo _repo;

  @override
  ResultFuture<LocalUser> call(String params) => _repo.getUserById(params);
}
