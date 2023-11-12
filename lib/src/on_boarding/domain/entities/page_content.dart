import 'package:education_app/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.img,
    required this.tittle,
    required this.description,
  });

  const PageContent.first()
      : this(
          img: MediaRes.casualReadingVect,
          tittle: 'Brand new curricullum',
          description: 'This is the first online education platform designed '
              "by the world's top professors",
        );

  const PageContent.second()
      : this(
          img: MediaRes.casualLifeVect,
          tittle: 'Brand a fun atmosphere',
          description: 'This is the first online education platform designed '
              "by the world's top professors",
        );

  const PageContent.third()
      : this(
          img: MediaRes.casualMeditationVect,
          tittle: 'Easy to join the lessaon',
          description: 'This is the first online education platform designed '
              "by the world's top professors",
        );

  final String img;
  final String tittle;
  final String description;

  @override
  List<Object?> get props => [img, tittle, description];
}
