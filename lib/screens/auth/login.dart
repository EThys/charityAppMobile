import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:donation/constants/images.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blurAnimationController;
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) return;

    if (AppRegex.passwordRegex.hasMatch(password)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
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
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Navigator.of(context).pop();
        SnackbarHelper.showSnackBar("Veuillez entrer vos identifiants.", isError: true);
        return;
      }

      if (!AppRegex.emailRegex.hasMatch(emailController.text)) {
        Navigator.of(context).pop();
        SnackbarHelper.showSnackBar("Veuillez entrer un email valide.", isError: true);
        return;
      }

      if (!AppRegex.passwordRegex.hasMatch(passwordController.text)) {
        Navigator.of(context).pop();
        SnackbarHelper.showSnackBar("Veuillez entrer un mot de passe valide.", isError: true);
        return;
      }

      // Vérification de la connexion Internet
      bool isConnected = await NetworkUtils.checkAndShowSnackBarIfNoConnection(context);
      if (!isConnected) {
        Navigator.of(context).pop(); // Fermer le CircularProgressIndicator
        print("Erreur de connexion");
        return;
      }

      // Préparation des données pour la connexion
      Map<String, dynamic> userData = {
        "email": emailController.text,
        "password": passwordController.text,
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
  void initState() {
    super.initState();
    _blurAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 0,
      upperBound: 6,
    )..forward();

    _blurAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _blurAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.loginBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
         // BlurContainer(value: _blurAnimationController.value),
          SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 600
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            _buildTitleText(context),
                            const SizedBox(height: 50),
                            AppTextFormField(
                              controller: emailController,
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
                                  controller: passwordController,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Action pour réinitialiser le mot de passe
                                  },
                                  child: const Text(
                                    'Mot de passe oublié ?',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitForm();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                child: const Text("Se connecter",style: TextStyle(color: Colors.white),),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 30,bottom: 30,left: 10,right: 10),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Vous n\'avez pas de compte ? ',
                                      style:
                                      TextStyle(fontSize: 15, color: Colors.black54),
                                    ),
                                    TextSpan(
                                      text: 'Créer un compte',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamed(context, Routes.signUpScreenRoute);
                                        },
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Column _buildTitleText(BuildContext context) {
    return Column(
      children: [
        Text(
          'SOS-Congo', // Application Name
          softWrap: true,
          style: TextStyle(
            fontSize: 30, // Adjust size as needed
            fontWeight: FontWeight.w800, // Make it stand out
            color: Colors.blue,       // Choose a suitable color
          ),
        ), // Add some spacing
        Text(
          'Bienvenue !',
          softWrap: true,
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          'Connectez-vous pour continuer',
          softWrap: true,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

}
