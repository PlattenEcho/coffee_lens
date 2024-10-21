import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Selamat datang di Coffee Lens ☕",
      "description": "Mulai hobi kopimu di Coffee Lens!",
      "image": "assets/onboarding1.jpg",
    },
    {
      "title": "Kenali lebih dalam biji kopi dan resepnya!",
      "description":
          "Dapatkan informasi menarik mengenai ragam biji kopi dan coba resep-resepnya!",
      "image": "assets/onboarding2.jpg",
    },
    {
      "title": "Deteksi jenis biji kopi dengan kameramu!",
      "description":
          "Gunakan teknologi machine learning untuk mengetahui jenis biji kopi!",
      "image": "assets/onboarding3.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: onboardingData.length,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  onboardingData[index]["image"]!,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: kSecondary3Color,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: onboardingData.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: kPrimaryColor,
                          dotColor: kGreyColor,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                      ),
                    ),
                    gapH(16),
                    Text(
                      onboardingData[currentIndex]["title"]!,
                      style: whiteTextStyle.copyWith(
                        fontWeight: bold,
                        fontSize: 32,
                      ),
                    ),
                    gapH(8),
                    Text(
                      onboardingData[currentIndex]["description"]!,
                      style: whiteTextStyle.copyWith(
                        color: kGreyColor,
                        fontWeight: light,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    gapH(16),
                    Button(
                      bgColor: kPrimaryColor,
                      color: kWhiteColor,
                      text: currentIndex == onboardingData.length - 1
                          ? "Masuk"
                          : "Selanjutnya",
                      onPressed: () {
                        if (currentIndex < onboardingData.length - 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, "/auth");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
