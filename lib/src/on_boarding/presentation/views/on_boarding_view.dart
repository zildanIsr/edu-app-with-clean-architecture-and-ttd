import 'package:education_app/core/common/views/loading.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/on_boarding/domain/entities/page_content.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cb_cubit.dart';
import 'package:education_app/src/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  static const routeName = '/';

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    context.read<OnBoardingCbCubit>().checkIfUserFirstTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnBoardingCbCubit, OnBoardingCbState>(
        listener: (context, state) {
          if (state is OnBoardingStatus && !state.isFirstTime) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is UserCached) {
            // TODO(User-Cached-Handler): Push to the appropriate screen
          }
        },
        builder: (context, state) {
          if (state is OnCheckingIfUserIsFirstTime ||
              state is OnCachingFirstTime) {
            return const LoadingView();
          }

          return Container(
            constraints: const BoxConstraints.expand(),
            child: Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: const [
                    OnBoardingBody(
                      pageContent: PageContent.first(),
                    ),
                    OnBoardingBody(
                      pageContent: PageContent.second(),
                    ),
                    OnBoardingBody(
                      pageContent: PageContent.third(),
                    ),
                  ],
                ),
                Align(
                  alignment: const Alignment(0, .04),
                  child: SmoothPageIndicator(
                    count: 3,
                    controller: pageController,
                    onDotClicked: (index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 40,
                      activeDotColor: Colours.primaryColour,
                      dotColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
