import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/LoginTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icons/ArrowLeft.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              textAlign: TextAlign.center,
              'Change Password',
              style: TextStyle(
                color: Color(0xFF111928),
                fontSize: 32,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w800,
                height: 1.38,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              width: 257,
              height: 48,
              child: Text(
                'Set up a new password that you’ll\nremember this time',
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
            const SizedBox(
              height: 24,
            ),
            CustomTextFormField(
                controller: _passwordController,
                label: "New Password",
                isPassword: true),
            SizedBox(
              height: 16,
            ),
            CustomTextFormField(
                controller: _confirmPasswordController,
                label: "Confirm password",
                isPassword: true),
            SizedBox(
              height: 16,
            ),
            CustomButton(label: "Continue", onTap: (){})
          ],
        ),
      ),
    );
  }
}
