import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:donation/constants/images.dart';
import 'package:provider/provider.dart';
import '../../components/app_regex.dart';
import '../../components/app_text_form_field.dart';
import '../../controllers/AuthentificationCtrl.dart';
import '../../utils/Routes.dart';
import '../../utils/helpers/snackbar_helper.dart';

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
    FocusScope.of(context).requestFocus(new FocusNode());
    // if (formKey.currentState?.validate() ?? false) {
    //   return;
    // }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    Map<String, dynamic> userData = {
      "email": emailController.text,
      "password": passwordController.text,
    };
    var ctrl = context.read<AuthentificationCtrl>();
    print("Voici les donnees $userData");
    var res = await ctrl.login(userData);
    await Future.delayed(Duration(seconds: 2));

    Navigator.of(context).pop();

    print("MAMADOUUUUU ${res.status}");
    print("MAMADOUUUUU ${res.status.runtimeType}");
    var isValidResponse = res.data != null;

    if (res.status==true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue.shade200,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.thumb_up, color: Colors.white, size: 60),
                SizedBox(height: 20),
                Text(
                  "Connexion réussie !",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          );
        },
      );

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, Routes.otpRoute);
      });
    } else {
      var errorMessage = res.data['errors']['credentials'] != null
          ? res.data['errors']['credentials'][0]
          : 'Erreur inconnue';
      SnackbarHelper.showSnackBar(errorMessage, isError: true);
    }
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
                            const SizedBox(height: 60),
                            _buildTitleText(context),
                            const SizedBox(height: 60),
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
                            ValueListenableBuilder(
                              valueListenable: passwordNotifier,
                              builder: (_, passwordObscure, __) {
                                return AppTextFormField(
                                  obscureText: passwordObscure,
                                  controller: passwordController,
                                  labelText: "Mot de passe",
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.visiblePassword,
                                  onChanged: (_) => _formKey.currentState?.validate(),
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? "Entrer un mot de passe"
                                        : AppRegex.passwordRegex.hasMatch(value)
                                        ? null
                                        : "Mot de passe invalid";
                                  },
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                    passwordNotifier.value = !passwordObscure,
                                    style: IconButton.styleFrom(
                                      minimumSize: const Size.square(48),
                                    ),
                                    icon: Icon(
                                      passwordObscure
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 20,
                                      color: Colors.black,
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
                            const SizedBox(height: 40),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitForm();
                                  passwordController.clear();
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
                            const SizedBox(height: 30),
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
          'Bienvenue !',
          softWrap: true,
          style:
          TextStyle(fontSize: 60, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        Text(
          'Connectez-vous pour continuer',
          softWrap: true,
          style:
          TextStyle(fontSize: 20, color: Colors.black),
        ),
      ],
    );
  }
}
