import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';

class SendMessage extends UsecaseWithParams<void, Message> {
  const SendMessage(this._repo);

  final ChatRepo _repo;

  @override
  ResultFuture<void> call(Message params) async => _repo.sendMessage(params);
}
