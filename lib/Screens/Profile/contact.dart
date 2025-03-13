import 'package:finesse_frontend/Widgets/cards/contactbutton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(
              "Centre d'aide",
              style: TextStyle(
                //color: Color(0xFF111928),
                fontSize: 18,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                height: 1.25,
                letterSpacing: 0.50,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ContactButton(text: 'Facebook', icon: Icons.facebook,),
            SizedBox(height: 24),
            ContactButton(text: 'Whatsapp',icon: FontAwesomeIcons.whatsapp,),
            SizedBox(height: 24),
            ContactButton(text: 'Instagram', icon: FontAwesomeIcons.instagram,),
          ],
        ),
      ),
    );
  }
}