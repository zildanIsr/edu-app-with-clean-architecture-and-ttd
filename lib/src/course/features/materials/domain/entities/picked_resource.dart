import 'package:equatable/equatable.dart';

class PickedResource extends Equatable {
  const PickedResource({
    required this.path,
    required this.title,
    required this.author,
    this.authorManuallyset = false,
    this.description = '',
  });

  final String path;
  final String title;
  final String author;
  final bool authorManuallyset;
  final String description;

  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool get stringify => true;

  PickedResource copyWith({
    String? path,
    String? title,
    String? author,
    bool? authorManuallyset,
    String? description,
  }) {
    return PickedResource(
      path: path ?? this.path,
      title: title ?? this.title,
      author: author ?? this.author,
      authorManuallyset: authorManuallyset ?? this.authorManuallyset,
      description: description ?? this.description,
    );
  }
}
