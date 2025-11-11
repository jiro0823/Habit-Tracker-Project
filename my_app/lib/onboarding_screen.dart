import 'package:flutter/material.dart';
import 'package:my_app/intro_screens/intro_page_1.dart';
import 'package:my_app/intro_screens/intro_page_2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: const [
              IntroPage1(),
              IntroPage2()
            ],
          ),
          
          Align(
            alignment: const Alignment(0, 0.75),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 2,
              effect: const WormEffect(
                activeDotColor: Colors.deepPurple,
                dotColor: Colors.grey,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 8,
              ),
            ),
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}