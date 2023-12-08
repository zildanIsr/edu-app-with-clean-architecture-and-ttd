import 'package:education_app/src/home/presentations/refactors/home_body.dart';
import 'package:education_app/src/home/presentations/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: const HomeBody(),
      ),
    );
  }
}
