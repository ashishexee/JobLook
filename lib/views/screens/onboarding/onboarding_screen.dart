import 'package:flutter/material.dart';
import 'package:job_look/controllers/onboarding_provider.dart';
import 'package:job_look/views/screens/onboarding/widget/PageOne.dart';
import 'package:job_look/views/screens/onboarding/widget/PageThree.dart';
import 'package:job_look/views/screens/onboarding/widget/PageTwo.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return Consumer<OnBoardNotifier>(
      builder: (context, onBoardNotifier, child) {
        return Scaffold(
          body: Stack(
            children: [
              PageView(
                physics:
                    onBoardNotifier.isLastPage == false
                        ? AlwaysScrollableScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                controller: pageController, 
                onPageChanged: (value) {
                  if (value == 2) {
                    onBoardNotifier.isLastPage = true;
                  }
                },
                children: [PageOne(), PageTwo(), PageThree()],
              ),
            ],
          ),
        );
      },
    );
  }
}
