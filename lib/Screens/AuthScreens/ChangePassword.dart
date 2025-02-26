import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignIn.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _arePasswordsMatching = false;
  bool _success = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePasswords);
    _confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_validatePasswords);
    _confirmPasswordController.removeListener(_validatePasswords);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    setState(() {
      _arePasswordsMatching = _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            const Text(
              textAlign: TextAlign.center,
              'Changer le mot de passe',
              style: TextStyle(
                //color: Color(0xFF111928),
                fontSize: 32,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w800,
                height: 1.38,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 257,
              height: 48,
              child: Text(
                "Définissez un nouveau mot de passe que vous\nvous souviendrez cette fois",
                textAlign: TextAlign.center,
                style: TextStyle(
                  //color: Color(0xFF111928),
                  fontSize: 16,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.38,
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              controller: _passwordController,
              label: "Nouveau mot de passe",
              isPassword: true,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _confirmPasswordController,
              label: "Confirmer le mot de passe",
              isPassword: true,
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: _success
                  ? "Terminé ✅"
                  : isLoading
                      ? "Chargement..."
                      : "Continuer",
              onTap: _arePasswordsMatching
                  ? () async {
                      setState(() {
                        isLoading = true;
                      });
                      String? storedResetToken =
                          await FlutterSecureStorage().read(key: 'reset_token');
                      final result =
                          await Provider.of<AuthService>(context, listen: false)
                              .changePassword(
                        resetToken: storedResetToken!,
                        password: _passwordController.text,
                      );
                      if (result.statusCode == 200) {
                        setState(() {
                          _success = true;
                        });
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                            (Route<dynamic> route) => false,
                          );
                        });
                      } else {
                        print(result.body);
                        setState(() {
                          _success = false;
                        });
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  : () {}, // Disable button if passwords don't match
              buttonColor: (_arePasswordsMatching)
                  ? const Color(0xFFFB98B7)
                  : const Color(0xFFE5E7EB),
              textColor: _arePasswordsMatching
                  ? Colors.white
                  : const Color(0xFF111928),
            ),
          ],
        ),
      ),
    );
  }
}
