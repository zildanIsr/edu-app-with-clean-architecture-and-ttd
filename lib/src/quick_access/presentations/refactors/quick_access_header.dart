import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/quick_access/presentations/provider/quick_access_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuickAccessHeader extends StatelessWidget {
  const QuickAccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuickAccTabController>(
      builder: (_, controller, __) {
        return Center(
          child: Image.asset(
            controller.currentIndex == 0
                ? MediaRes.bluePotVect
                : controller.currentIndex == 1
                    ? MediaRes.turquoisePotVect
                    : MediaRes.streamCupVect,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
