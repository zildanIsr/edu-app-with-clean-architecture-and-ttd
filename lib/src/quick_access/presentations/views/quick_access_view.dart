import 'package:education_app/src/quick_access/presentations/refactors/quick_access_app_bar.dart';
import 'package:education_app/src/quick_access/presentations/refactors/quick_access_header.dart';
import 'package:education_app/src/quick_access/presentations/refactors/quick_access_tab_bar.dart';
import 'package:education_app/src/quick_access/presentations/refactors/quick_access_tab_body.dart';
import 'package:flutter/material.dart';

class QuickAccessView extends StatelessWidget {
  const QuickAccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: const QuickAccessAppBar(),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: const Center(
          child: Column(
            children: [
              Expanded(flex: 2, child: QuickAccessHeader()),
              Expanded(child: QuickAccessTabBar()),
              Expanded(flex: 2, child: QuickAccessTabBody()),
            ],
          ),
        ),
      ),
    );
  }
}
