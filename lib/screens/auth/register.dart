import 'package:donation/models/RoleModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/app_regex.dart';
import '../../components/app_text_form_field.dart';
import '../../controllers/AuthentificationCtrl.dart';
import '../../utils/Routes.dart';
import '../../utils/SuccessAlertDialog.dart';
import '../../utils/helpers/snackbar_helper.dart';
import '../../utils/networkCheck.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = '/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blurAnimationController;
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  late TextEditingController nameController = TextEditingController();
  late TextEditingController firstnameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  late TextEditingController countryController = TextEditingController();
  late TextEditingController cityController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

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

    // Initialize controllers
    nameController = TextEditingController();
    firstnameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    cityController = TextEditingController();
    countryController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _blurAnimationController.dispose();
    firstnameController.dispose();
    emailController.dispose();
    cityController.dispose();
    countryController.dispose();
    phoneController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  int? roleId;
  final List<RoleModel> roleList = [
    RoleModel(id: 1, name: "Administrateur"),
    RoleModel(id: 2, name: "Organisation humanitaire"),
    RoleModel(id: 3, name: "Bénéficiaire"),
    RoleModel(id: 4, name: "Donateur"),
  ];

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

      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          nameController.text.isEmpty ||
          firstnameController.text.isEmpty ||
          countryController.text.isEmpty ||
          cityController.text.isEmpty ||
          phoneController.text.isEmpty) {
        Navigator.of(context).pop();
        SnackbarHelper.showSnackBar("Veuillez remplir tous les champs.", isError: true);
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

      bool isConnected = await NetworkUtils.checkAndShowSnackBarIfNoConnection(context);
      if (!isConnected) {
        Navigator.of(context).pop();
        print("Erreur de connexion");
        return;
      }

      Map<String, dynamic> userData = {
        "name": nameController.text,
        "firstname": firstnameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "city": cityController.text,
        "country": countryController.text,
        "password": passwordController.text,
      };

      var ctrl = context.read<AuthentificationCtrl>();
      print("Données envoyées : $userData");
      var res = await ctrl.register(userData);

      Navigator.of(context).pop();

      if (res.status == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const SuccessDialog(
              title: "Inscription réussie !",
              subtitle: "Ensemble, nous pouvons apporter de l'espoir avec SOS CONGO.",
              icon: FontAwesomeIcons.checkCircle,
              iconColor: Colors.green,
            );
          },
        );

        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, Routes.logInScreenRoute);
        });
      } else {
        SnackbarHelper.showSnackBar(res.data?['error'], isError: true);
      }
    }

    await submitProcess();
  }

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      if (_currentPage < 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage++;
        });
      } else {
        _submitForm();
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade400],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.handsHelping, // Icône de charité
                                      size: 60,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 10), // Espace entre l'icône et le texte
                                    const Text(
                                      'SOS CONGO',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.blue, // Vous pouvez personnaliser cette couleur
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20), // Espacement
                                // Ajout du texte "Connexion"
                                Text(
                                  'Inscrivez-vous',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 400,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                    child: PageView(
                                      controller: _pageController,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        _buildStep1(),
                                        _buildStep2(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentPage > 0)
                              ElevatedButton(
                                onPressed: _previousPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                child: const Text("Précédent", style: TextStyle(color: Colors.blue)),
                              ),
                            ElevatedButton(
                              onPressed: _nextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                              child: Text(
                                _currentPage == 1 ? "S'inscrire" : "Suivant",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Vous avez déjà un compte ? ',
                                    style: TextStyle(fontSize: 15, color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'Connectez-vous',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(context, Routes.logInScreenRoute);
                                      },
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        AppTextFormField(
          controller: nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          labelText: 'Prénom',
          validator: (value) => value!.isEmpty ? 'Entrer votre prénom' : null,
        ),
        const SizedBox(height: 10),
        AppTextFormField(
          controller: firstnameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          labelText: 'Nom',
          validator: (value) => value!.isEmpty ? 'Entrer votre nom' : null,
        ),
        const SizedBox(height: 10),
        AppTextFormField(
          labelText: "Email",
          controller: emailController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => _formKey.currentState?.validate(),
          validator: (value) {
            return value!.isEmpty
                ? "Entrez votre email"
                : AppRegex.emailRegex.hasMatch(value)
                ? null
                : "Entrez un email valide";
          },
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Colors.grey.shade700,
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: CustomDropdown<RoleModel>(
              hintText: 'Type de compte',
              items: roleList,
              decoration: CustomDropdownDecoration(
                expandedBorder: Border.all(
                  color: Colors.grey,
                ),
                hintStyle: const TextStyle(color: Colors.black54),
              ),
              onChanged: (selectedRole) {
                if (selectedRole != null) {
                  roleId = selectedRole.id;
                  print('ID du type de compte sélectionné : ${roleId}');
                  print('Titre du compte : ${selectedRole.name}');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        AppTextFormField(
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          controller: countryController,
          labelText: 'Pays',
          onChanged: (_) => _formKey.currentState?.validate(),
          validator: (value) => value!.isEmpty ? 'Entrez votre pays' : null,
        ),
        const SizedBox(height: 10),
        AppTextFormField(
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          controller: cityController,
          labelText: 'Ville',
          onChanged: (_) => _formKey.currentState?.validate(),
          validator: (value) => value!.isEmpty ? 'Entrez votre ville' : null,
        ),
        const SizedBox(height: 10),
        AppTextFormField(
          labelText: "Téléphone",
          controller: phoneController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          onChanged: (_) => _formKey.currentState?.validate(),
          validator: (value) {
            return value!.isEmpty
                ? "Entrez un numéro de téléphone"
                : value.length > 14
                ? "Entrez un numéro de téléphone valide"
                : null;
          },
        ),
        const SizedBox(height: 10),
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
                    ? "Entrez votre mot de passe"
                    : AppRegex.passwordRegex.hasMatch(value)
                    ? null
                    : "Entrez un mot de passe avec huit caractères";
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
      ],
    );
  }

  Column _buildTitleText(BuildContext context) {
    return Column(
      children: [
        Text(
          'SOS-Congo',
          softWrap: true,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          'Bienvenue !',
          softWrap: true,
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          'Inscrivez-vous pour continuer',
          softWrap: true,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}