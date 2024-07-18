import 'package:flutter/material.dart';

import '../main.dart';
import 'onboarding_page.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(219, 219, 255, 204),
              Color.fromARGB(223, 253, 255, 237),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  OnboardingPage(
                    title: 'Sales Stats',
                    description: 'Where you can track your sales everywhere!',
                    imagePath: 'assets/images/logo.png',
                  ),
                  OnboardingPage(
                    title: 'Track Sales',
                    description: 'Easily track and manage your sales data.',
                    imagePath: 'assets/images/sales.png',
                  ),
                  OnboardingPage(
                    title: 'Analyze Trends',
                    description: 'Analyze sales trends and make informed decisions.',
                    imagePath: 'assets/images/analysis.png',
                  ),
                  OnboardingPage(
                    title: 'Get Started',
                    description: 'Sign in or register to get started.',
                    imagePath: 'assets/images/get_started.png',
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage == 3) {
                          Navigator.pushReplacementNamed(context, MyApp.loginRoute);
                        } else {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 50),
                        backgroundColor: Color.fromARGB(255, 14, 161, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _currentPage == 3 ? 'Get Started' : 'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, MyApp.loginRoute);
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
