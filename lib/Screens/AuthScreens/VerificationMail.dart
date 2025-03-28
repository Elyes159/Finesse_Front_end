import 'package:finesse_frontend/Models/user.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Screens/AuthScreens/ChangePassword.dart';
import 'package:finesse_frontend/Screens/AuthScreens/CompleteInfo.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class VerificationMail extends StatefulWidget {
  final String parametre;
  final String? email;
  const VerificationMail({super.key, this.email, required this.parametre});

  @override
  State<VerificationMail> createState() => _VerificationMailState();
}

class _VerificationMailState extends State<VerificationMail> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  Users? user;
  final storage = FlutterSecureStorage();
  bool _isResendingCode = false;
  int _remainingTime = 10; // Temps restant en secondes

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text(
            "Nous avons envoyé votre code à ${widget.email ?? "votre email"}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(
            width: 343,
            height: 30,
            child: Text(
              "Entrez le code à 6 chiffres",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 48.83,
                  height: 56,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                    ),
                  ),
                  child: TextField(
                    cursorColor: Colors.grey,
                    controller: _controllers[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color(0xFF111928),
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomButton(
              label: "Suivant",
              onTap: () async {
                try {
                  if (widget.parametre == "signup") {
                    await Provider.of<AuthService>(context, listen: false)
                        .confirmEmailVerification(
                      userId: Provider.of<AuthService>(context, listen: false)
                          .userId,
                      verificationCode: _controllers
                          .map((controller) => controller.text)
                          .join(''),
                    );
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompleteInfo(
                                  parameter: "normal",
                                )));
                  } else {
                    String? storedemailReset =
                        await storage.read(key: 'email_reset');
                    await Provider.of<AuthService>(context, listen: false)
                        .confirmEmailVerificationForReset(
                      email: storedemailReset!,
                      verificationCode: _controllers
                          .map((controller) => controller.text)
                          .join(''),
                    );
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword()));
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print("ereir ${e.toString()}");
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _isResendingCode
                    ? null
                    : () async {
                        // Mettre à jour l'état pour afficher le compte à rebours
                        setState(() {
                          _isResendingCode = true;
                          _remainingTime = 10;
                        });

                        // Appeler la fonction resend_code
                        bool result = await Provider.of<AuthService>(context,
                                listen: false)
                            .resend_code(email: widget.email);

                        if (result) {
                          // Commencer le compte à rebours
                          await _startCountdown();
                        }
                      },
                child: Text(
                  _isResendingCode
                      ? "Renvoyer le code ($_remainingTime)"
                      : "Renvoyer le code",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    color: _isResendingCode
                        ? Colors.grey
                        : theme
                            ? Color.fromARGB(255, 249, 217, 144)
                            : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour démarrer le compte à rebours
  Future<void> _startCountdown() async {
    while (_remainingTime > 0) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _remainingTime--;
      });
    }

    // Une fois le compte à rebours terminé, réinitialiser les variables
    setState(() {
      _isResendingCode = false;
    });
  }
}
