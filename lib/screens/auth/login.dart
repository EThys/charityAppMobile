import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/app_regex.dart';
import '../../components/app_text_form_field.dart';
import '../../controllers/AuthentificationCtrl.dart';
import '../../utils/Routes.dart';
import '../../utils/SuccessAlertDialog.dart';
import '../../utils/helpers/snackbar_helper.dart';
import '../../utils/networkCheck.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier(true);
  bool _isLoading = false;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordNotifier.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.yellow,
          ),
        );
      },
    );

    Future<void> submitProcess() async {
      FocusScope.of(context).requestFocus(FocusNode());

      // Vérifications des champs
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        Navigator.of(context).pop();
        SnackbarHelper.showSnackBar("Veuillez entrer vos identifiants.", isError: true);
        return;
      }

      // if (!AppRegex.emailRegex.hasMatch(emailController.text)) {
      //   Navigator.of(context).pop();
      //   SnackbarHelper.showSnackBar("Veuillez entrer un email valide.", isError: true);
      //   return;
      // }
      //
      // if (!AppRegex.passwordRegex.hasMatch(passwordController.text)) {
      //   Navigator.of(context).pop();
      //   SnackbarHelper.showSnackBar("Veuillez entrer un mot de passe valide.", isError: true);
      //   return;
      // }

      // Vérification de la connexion Internet
      bool isConnected = await NetworkUtils.checkAndShowSnackBarIfNoConnection(context);
      if (!isConnected) {
        Navigator.of(context).pop(); // Fermer le CircularProgressIndicator
        print("Erreur de connexion");
        return;
      }

      // Préparation des données pour la connexion
      Map<String, dynamic> userData = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      // Appel au contrôleur d'authentification
      var ctrl = context.read<AuthentificationCtrl>();
      print("Données envoyées : $userData");
      var res = await ctrl.login(userData);

      // Fermer le CircularProgressIndicator après la réponse
      Navigator.of(context).pop();

      // Traitement de la réponse
      if (res.status == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const SuccessDialog(
              title: "Connexion réussie !",
              subtitle: "Vous êtes maintenant connecté(e) à votre compte.",
              icon: FontAwesomeIcons.checkCircle,
              iconColor: Colors.green,
            );
          },
        );

        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pop(); // Fermer le SuccessDialog
          Navigator.pushNamed(context, Routes.otpRoute); // Rediriger vers la page OTP
        });
      } else {
        var errorMessage = res.data['errors']['credentials'] != null
            ? res.data['errors']['credentials'][0]
            : 'Erreur inconnue';
        SnackbarHelper.showSnackBar(errorMessage, isError: true);
      }
    }

    // Lancer le processus de soumission
    await submitProcess();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade400],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color:Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.handsHelping, // Charity icon
                            size: 60,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 10), // Space between icon and text
                          const Text(
                            'SOS CONGO',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.blue, // You can customize this color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                        const SizedBox(height: 20),
                        Text(
                          'Connexion',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppTextFormField(
                          controller: _emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => _formKey.currentState?.validate(),
                          validator: (value) {
                            return value!.isEmpty
                                ? "Entre votre email"
                                : AppRegex.emailRegex.hasMatch(value)
                                ? null
                                : "Entre un email valid";
                          },
                        ),  const SizedBox(height: 20),
                        ValueListenableBuilder<bool>(
                          valueListenable: passwordNotifier,
                          builder: (_, passwordObscure, __) {
                            return AppTextFormField(
                              obscureText: passwordObscure,
                              controller: _passwordController,
                              labelText: "Mot de passe",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: (_) => _formKey.currentState?.validate(),
                              validator: (value) {
                                return value!.isEmpty
                                    ? "Entrer votre mot de passe"
                                    : AppRegex.passwordRegex.hasMatch(value)
                                    ? null
                                    : "Entrer un mot de passe avec huit caracteres";
                              },
                              suffixIcon: Focus(
                                child: IconButton(
                                  onPressed: () =>
                                  passwordNotifier.value = !passwordObscure,
                                  style: IconButton.styleFrom(
                                    minimumSize: const Size.square(48),
                                  ),
                                  icon: Icon(
                                    passwordObscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.orange)
                                : const Text(
                              'Se connecter',
                              style: TextStyle(fontSize: 18,color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            // Naviguer vers l'écran de réinitialisation du mot de passe
                          },
                          child: const Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Pas de compte ? "),
                            TextButton(
                              onPressed: () {
                              Navigator.pushNamed(context, Routes.signUpScreenRoute);
                              },
                              child: const Text(
                                'S\'inscrire',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}