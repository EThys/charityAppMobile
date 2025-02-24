import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../constants/images.dart';
import '../../controllers/AuthentificationCtrl.dart';
import '../../utils/Routes.dart';
import 'dart:async';
import '../../utils/networkCheck.dart';

class OtpScreen extends StatefulWidget {
  static const String id = '/otp';
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late int _secondsRemaining;
  late Timer _timer;
  bool _isResendEnabled = false;
  String _otpCode = "";

  @override
  void initState() {
    super.initState();
    _secondsRemaining = 600; // 10 minutes en secondes
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isResendEnabled = true; // Active le bouton "Renvoyer le code"
        });
        _timer.cancel();
      }
    });
  }

  String _formatTimer(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _resendCode() {
    if (_isResendEnabled) {
      // Logic to resend OTP
      setState(() {
        _secondsRemaining = 600; // Reset timer
        _isResendEnabled = false;
      });
      _startTimer();
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpCode.length == 6) {
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

      bool isConnected = await NetworkUtils.checkAndShowSnackBarIfNoConnection(context);
      if (!isConnected) {
        print("Erreur de connexion");
        return;
      }

      var ctrl = context.read<AuthentificationCtrl>();
      var res = await ctrl.verifyOtp({"code": _otpCode});
      Navigator.of(context).pop();

      print("Réponse de l'API : $res");

      if (res.status == true) {
        Navigator.pushReplacementNamed(context, Routes.otpSuccessRoute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(res.data?['error'] ?? "Erreur lors de la vérification")),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text("Veuillez entrer un code OTP valide")),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity, // Prend toute la largeur de l'écran
        height: double.infinity, // Prend toute la hauteur de l'écran
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade400], // Dégradé bleu
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600), // Limite la largeur de la carte
                child: Padding(
                  padding: const EdgeInsets.only(top: 70.0,left: 20.0,right: 20.0,bottom: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 5, // Ombre légère
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Bordures arrondies
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Pour que la carte s'adapte au contenu
                            children: [
                              FaIcon(
                                FontAwesomeIcons.envelope,
                                size: 80,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Nous avons envoyé un code à votre mail",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                              const SizedBox(height: 45),
                              PinCodeTextField(
                                appContext: context,
                                length: 6,
                                onChanged: (value) {
                                  setState(() {
                                    _otpCode = value; // Met à jour le code OTP
                                  });
                                },
                                onCompleted: (value) {
                                  setState(() {
                                    _otpCode = value; // Met à jour le code OTP lorsque complet
                                  });
                                  _verifyOtp(); // Vérifie le code lorsque l'utilisateur a terminé la saisie
                                },
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(8),
                                  fieldHeight: 40,
                                  fieldWidth: 40,
                                  inactiveColor: Colors.black,
                                  activeColor: Colors.blue.shade400,
                                  selectedColor: Colors.blue.shade400,
                                ),
                                cursorColor: Colors.blue.shade400,
                              ),
                              const SizedBox(height: 70),
                              GestureDetector(
                                onTap: _isResendEnabled ? _resendCode : null,
                                child: Text(
                                  "Vous n'avez pas reçu le code ? Renvoyer le code",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _isResendEnabled ? Colors.blue : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Le code expire dans ${_formatTimer(_secondsRemaining)}",
                                style: const TextStyle(fontSize: 16, color: Colors.red),
                              ),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                onPressed: _verifyOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                child: const Text("Vérifier", style: TextStyle(color: Colors.white)),
                              ),
                            ],
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
    );
  }
}