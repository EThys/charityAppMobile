import 'package:donation/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/StockageKeys.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;
  var _stockage = GetStorage();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            buildPage(
              color: Colors.white,
              urlImage: 'assets/images/charity_2.jpg',
              title: 'CREER UNE CAMPAGNE',
              subtitle:
              'Partagez votre histoire, même celle difficile de la RDC, et lancez une campagne pour collecter des fonds pour soutenir votre cause et reconstruire l\'espoir.',
            ),
            buildPage(
              color: Colors.white,
              urlImage: 'assets/images/charity.jpg',
              title: 'FAIRE UN DON FACILEMENT',
              subtitle:
              'Soutenez les initiatives en RDC qui œuvrent pour la paix, l\'éducation et la reconstruction après plus de 25 ans de conflits. Chaque don compte.',
            ),
            buildPage(
              color: Colors.white,
              urlImage: 'assets/images/charity_1.jpg',
              title: 'SUIVEZ VOTRE IMPACT EN RDC',
              subtitle:
              'Voyez concrètement comment vos dons contribuent à améliorer la vie des communautés affectées par la guerre et à bâtir un avenir meilleur pour la RDC.',
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor: Colors.blue.shade500,
          minimumSize: const Size.fromHeight(80),
        ),
        child: const Text(
          'Commencer',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        onPressed: () async {
          await _stockage.write(StockageKeys.firstLaunchKey, false);
          Navigator.pushReplacementNamed(context, Routes.homeRoute);
        },
      )
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.blue.shade500,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text('Sauter', style: TextStyle(color: Colors.white)),
              onPressed: () => controller.jumpToPage(2),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  spacing: 16,
                  dotColor: Colors.black26,
                  activeDotColor: Colors.white,
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                ),
              ),
            ),
            TextButton(
              child: const Text('Suivant', style: TextStyle(color: Colors.white)),
              onPressed: () => controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
  }) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              urlImage,
              height: 400,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(  // Wrap the Text and Divider in a Column
                crossAxisAlignment: CrossAxisAlignment.start, // Align the Divider to the start
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 4),
                  Divider(
                    color: Colors.blue.shade700,
                    thickness: 2,
                    endIndent: 100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                subtitle,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ),
          ],
        ),
      );



}