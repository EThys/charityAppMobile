import 'package:donation/screens/auth/register.dart';
import 'package:donation/screens/home/HistoryCongoScreen.dart';
import 'package:donation/screens/profile/header.dart';
import 'package:donation/screens/profile/privacyPolicy.dart';
import 'package:donation/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/Routes.dart';
import '../../utils/StockageKeys.dart';
import '../auth/login.dart';
import 'ConditionDutilisation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GetStorage storage = GetStorage();
  bool _isDarkMode = false;
  String ? _selectedLanguage="Français";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
         SliverPadding(padding: EdgeInsets.all(20.0)),
          SliverToBoxAdapter(
            child: ProfileHeader(storage: storage),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTitle("Informations personnelles"),
              _buildProfileOption("Email : ${storage.read(StockageKeys.userKey)?['email'] ?? ''}", Icons.email),
              _buildProfileOption("Ville : ${storage.read('userKey')?['address'] ?? ''}", Icons.location_on),
              _buildSectionTitle("Paramètres"),
              // _buildSwitchOption("Mode sombre", Icons.dark_mode, _isDarkMode, (value) {
              //   setState(() {
              //     _isDarkMode = value;
              //   });
              // }),
              _buildProfileOption(
                "Langue : $_selectedLanguage",
                Icons.language,
                onTap: () => _showLanguageSelectionPopup(context),
              ),
              _buildProfileOptionButton(context, "Histoire", FontAwesomeIcons.clockRotateLeft, HistoryCongoScreen()),
              _buildProfileOptionButton(context, "Se connecter", Icons.login, LoginScreen()),
              _buildProfileOptionButton(context, "Inscription", Icons.person_add, RegisterScreen()),
              _buildProfileOptionButton(context,"Politique de Confidentialité", Icons.lock,PrivacyPolicyPage()),
              _buildProfileOptionButton(context,"Conditions d'Utilisation", Icons.description,ConditionsDUtilisationPage()),
              _buildSectionTitle("Actions"),
              _buildActionOption("Se déconnecter", Icons.logout, Colors.red, () {
                storage.remove(StockageKeys.userKey);
                storage.remove(StockageKeys.tokenKey);
                Navigator.pushReplacementNamed(context, Routes.logInScreenRoute);
              }),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildProfileOptionButton(BuildContext context, String title, IconData icon, Widget destinationPage) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigation vers la page correspondante
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
    );
  }

  void _showLanguageSelectionPopup(BuildContext context) {
    showMenu(
      color: Colors.white,
      context: context,
      position: RelativeRect.fromLTRB(100, 400, 0, 0), // Position du menu (ajustez selon vos besoins)
      items: [
        PopupMenuItem(
          value: 'Français',
          child: _buildLanguageOption('Français', 'assets/images/france.png'),
        ),
        PopupMenuItem(
          value: 'Anglais',
          child: _buildLanguageOption('Anglais', 'assets/images/english.png'),
        ),
      ],
      elevation: 8.0,
    );
  }
  Widget _buildLanguageOption(String language, String flagAsset) {
    return ListTile(
      leading: Image.asset(flagAsset, width: 30, height: 30),
      title: Text(language),
      onTap: () {
        setState(() {
          _selectedLanguage = language; // Mettre à jour la langue sélectionnée
        });
        Navigator.pop(context); // Fermer la popup
      },
    );
  }

  Widget _buildProfileOption(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchOption(String title, IconData icon, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildActionOption(String title, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontSize: 16, color: color)),
      onTap: onTap,
    );
  }
}