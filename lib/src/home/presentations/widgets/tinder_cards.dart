import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/src/home/presentations/widgets/tinder_card.dart';
import 'package:flutter/material.dart';

class TinderCards extends StatefulWidget {
  const TinderCards({super.key});

  @override
  State<TinderCards> createState() => _TinderCardsState();
}

class _TinderCardsState extends State<TinderCards>
    with TickerProviderStateMixin {
  final AppinioSwiperController controller = AppinioSwiperController();

  int totalCards = 10;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: context.widht,
        width: context.widht,
        child: AppinioSwiper(
          backgroundCardOffset: const Offset(0, 15),
          controller: controller,
          cardCount: totalCards,
          onEnd: () {
            const Text('No more materials');
            setState(() {
              totalCards += 10;
            });
          },
          cardBuilder: (context, index) {
            final isFirst = index == 0;
            final colorByIndex =
                index == 1 ? const Color(0xFFDA92FC) : const Color(0xFFDC95FB);
            return Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 120,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 50,
                      bottom: 40,
                    ),
                    child: Tindercard(
                      isFirst: isFirst,
                      colour: isFirst ? null : colorByIndex,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
