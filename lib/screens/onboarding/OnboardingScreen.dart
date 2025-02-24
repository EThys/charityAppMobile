import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:donation/utils/Routes.dart';
import 'package:donation/utils/StockageKeys.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;
  final _storage = GetStorage();

  @override
  void dispose() {
    controller.dispose();
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
              Colors.blue.shade800,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: Stack(
          children: [
            PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() => isLastPage = index == 2);
              },
              children: [
                buildPage(
                  urlImage: 'assets/images/charity_2.jpg',
                  title: 'CREER UNE CAMPAGNE',
                  subtitle:
                  'Partagez votre histoire, même celle difficile de la RDC, et lancez une campagne pour collecter des fonds pour soutenir votre cause et reconstruire l\'espoir.',
                  icon: Icons.campaign,
                ),
                buildPage(
                  urlImage: 'assets/images/charity.jpg',
                  title: 'FAIRE UN DON FACILEMENT',
                  subtitle:
                  'Soutenez les initiatives en RDC qui œuvrent pour la paix, l\'éducation et la reconstruction après plus de 25 ans de conflits. Chaque don compte.',
                  icon: Icons.volunteer_activism,
                ),
                buildPage(
                  urlImage: 'assets/images/charity_1.jpg',
                  title: 'SUIVEZ VOTRE IMPACT EN RDC',
                  subtitle:
                  'Voyez concrètement comment vos dons contribuent à améliorer la vie des communautés affectées par la guerre et à bâtir un avenir meilleur pour la RDC.',
                  icon: Icons.track_changes,
                ),
              ],
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.yellow.shade700,
                    dotColor: Colors.white.withOpacity(0.5),
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Container(
        height: 80,
        color: Colors.blue.shade500,
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Commencer',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () async {
              await _storage.write(StockageKeys.firstLaunchKey, false);
              Navigator.pushReplacementNamed(context, Routes.homeRoute);
            },
          ),
        ),
      )
          : Container(
        height: 80,
        color: Colors.blue.shade500,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text(
                'Sauter',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => controller.jumpToPage(2),
            ),
            TextButton(
              child: const Text(
                'Suivant',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
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
    required String urlImage,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              urlImage,
              height: 300,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 40),
          Icon(
            icon,
            size: 50,
            color: Colors.yellow.shade700,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Divider(
            color: Colors.yellow.shade700,
            thickness: 2,
            indent: 100,
            endIndent: 100,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}