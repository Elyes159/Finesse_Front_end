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
                color: Color(0xFF111928),
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
            Row(
              children: [
                Icon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 28),
                SizedBox(width: 15),
                Text(
                  "WhatsApp",
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Icon(FontAwesomeIcons.facebook, color: Colors.blue, size: 28),
                SizedBox(width: 15),
                Text(
                  "Facebook",
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Icon(FontAwesomeIcons.instagram, color: Colors.purple, size: 28),
                SizedBox(width: 15),
                Text(
                  "Instagram",
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}