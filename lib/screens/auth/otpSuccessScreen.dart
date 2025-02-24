import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/Routes.dart';
import '../../constants/images.dart'; // Import your images constants

class OtpSuccessScreen extends StatelessWidget {
  static const String id = '/otp_success';

  const OtpSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade400], // Dégradé bleu
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 5, // Ombre légère
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bordures arrondies
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Pour que la carte s'adapte au contenu
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.checkCircle, // Icône de validation
                      size: 100,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Vérification OTP réussie !",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Votre compte a été vérifié avec succès.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Routes.homeRoute); // Redirection vers la page d'accueil
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text(
                        "D'accord",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}