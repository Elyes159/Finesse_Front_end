import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Screens/AuthScreens/SignUpScreen.dart';
import 'package:finesse_frontend/Screens/HomeScreen/HomeScreen.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/SocialMediaSignIn.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/LoginTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 96,),
            const Text(
              'Welcome',
              style: TextStyle(
                color: Color(0xFF111928),
                fontSize: 32,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                height: 1.38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),
            const SizedBox(
              width: 251,
              height: 48,
              child: Text(
                'Enter your e-mail or username\nand password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF111928),
                  fontSize: 16,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  height: 1.38,
                ),
              ),
            ),
            const SizedBox(height: 24,),
            // Formulaire avec validation
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _usernameController,
                    label: "Username or Email",
                    isPassword: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username or email';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['username'] = value!,
                  ),
                  const SizedBox(height: 16,),
                  CustomTextFormField(
                    controller: _passwordController,
                    label: "Your password",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData['password'] = value!,
                  ),
                  const SizedBox(height: 16,),
                 CustomButton(
                  label: "Login",
                  onTap: () async {
                    // Sauvegarder les valeurs si la validation est réussie
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Ne s'exécute que si la validation réussit
                      try {
                        await authService.signIn(
                          username: _formData['username']!,
                          password: _formData['password']!,
                        );
                        final user = authService.currentUser;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,  // Supprimer toutes les routes précédentes
                        );
                      } catch (e) {
                        // Gérer l'erreur ici si nécessaire
                      }
                    } else {
                      // Ajoutez éventuellement un message d'erreur si la validation échoue
                    }
                  },
                ),

                ],
              ),
            ),
            SizedBox(height: 32,),
            Text(
              'Or use',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111928),
                fontSize: 14,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 14,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(onTap: (){}, imagePath: "assets/Icons/google.svg",),
                SizedBox(width: 8.86,),
                CustomContainer(onTap: (){}, imagePath: "assets/Icons/facebook.svg"),
                SizedBox(width: 8.86,),
                CustomContainer(onTap: (){}, imagePath: "assets/Icons/apple.svg"),
              ],
            ),
            SizedBox(height: 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No account yet?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF111928),
                    fontSize: 16,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                  },
                  child: Text(
                    ' Sign up now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFC668AA),
                      fontSize: 16,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
