import 'package:finesse_frontend/Widgets/cards/contactbutton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';  // Importer le package url_launcher

class Contact extends StatelessWidget {
  const Contact({super.key});

  // Fonction pour lancer une URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'ouvrir l\'URL $url';
    }
  }

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
            InkWell(
              onTap: () => _launchURL('https://www.facebook.com/share/1A9MByRYXA/'),  // Lien vers Facebook
              child: ContactButton(
                text: 'Facebook',
                icon: Icons.facebook,
              ),
            ),
            SizedBox(height: 24),
            InkWell(
              onTap: () => _launchURL('https://wa.me/+21658118643'),  // Lien vers WhatsApp avec le numéro
              child: ContactButton(
                text: 'Whatsapp',
                icon: FontAwesomeIcons.whatsapp,
              ),
            ),
            SizedBox(height: 24),
            InkWell(
              onTap: () => _launchURL('https://www.instagram.com/finos.tn?igsh=MTJ3ajJ6MW1ibGFpaA=='),  // Lien vers Instagram
              child: ContactButton(
                text: 'Instagram',
                icon: FontAwesomeIcons.instagram,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
