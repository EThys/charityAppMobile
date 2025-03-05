import 'package:flutter/material.dart';

class ConditionsDUtilisationPage extends StatelessWidget {
  const ConditionsDUtilisationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Conditions d'Utilisation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dernière mise à jour : Février 2025",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              const Text(
                "1. Introduction",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Bienvenue sur notre plateforme de financement participatif. "
                    "En utilisant nos services, vous acceptez ces conditions d'utilisation.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "2. Utilisation des Services",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Vous devez utiliser nos services pour des fins légitimes et conformes aux lois applicables. "
                    "Toute utilisation abusive ou frauduleuse est interdite.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "3. Compte Utilisateur",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Pour utiliser nos services, vous devez créer un compte. "
                    "Vous êtes responsable de la confidentialité de vos informations de connexion.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "4. Contenu Utilisateur",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Vous êtes responsable du contenu que vous publiez sur notre plateforme. "
                    "Ce contenu ne doit pas être illégal, offensant ou préjudiciable à autrui.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "5. Paiements et Transactions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tous les paiements et transactions effectués via notre plateforme sont soumis à nos conditions de paiement et aux politiques des fournisseurs de services de paiement.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "6. Responsabilité et Limitation de Responsabilité",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Nous ne sommes pas responsables des dommages résultant de l'utilisation de nos services, sauf dans les cas où la loi l'exige.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "7. Modification des Conditions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Nous nous réservons le droit de modifier ces conditions d'utilisation à tout moment. "
                    "Il est de votre responsabilité de vérifier régulièrement ces conditions.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
