import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Politique de Confidentialité',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Chez Art Zi, nous nous engageons à protéger votre vie privée et à respecter les lois et régulations en vigueur en Tunisie concernant la protection des données personnelles. Cette politique de confidentialité explique comment nous collectons, utilisons, protégeons et partageons vos informations personnelles lorsque vous utilisez notre application mobile.",
              style: TextStyle(fontFamily: 'Raleway', fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '1. Collecte des informations personnelles',
              style: TextStyle(fontFamily: 'Raleway', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Nous collectons des informations personnelles vous concernant lorsque vous utilisez notre application mobile de dépôt-vente, y compris :\n• Informations d’identification personnelle : Votre nom, adresse e-mail, numéro de téléphone, adresse physique, etc.\n• Informations financières : Détails de votre carte bancaire ou informations relatives aux services de paiement tiers utilisés pour vos transactions.\n• Données d’utilisation : Nous collectons des informations sur l’utilisation de notre application (pages visitées, actions effectuées, articles ajoutés à votre panier, etc.).\n• Données liées à vos transactions : Historique des achats et ventes effectuées sur notre plateforme, ainsi que des informations sur la livraison et l’expédition.\n• Données de géolocalisation (si vous l’activez) : Nous pouvons collecter votre localisation pour faciliter la livraison de vos articles.",
              style: TextStyle(fontFamily: 'Raleway', fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '2. Utilisation de vos informations personnelles',
              style: TextStyle(fontFamily: 'Raleway', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Nous utilisons vos informations personnelles pour :\n• Fournir nos services et produits, traiter vos achats, gérer vos ventes, et assurer la livraison de vos articles.\n• Personnaliser votre expérience utilisateur et améliorer nos services.\n• Vous envoyer des notifications relatives à votre compte, vos commandes ou toute autre activité liée à l’application.\n• Vous informer de nouvelles offres, promotions, et autres informations susceptibles de vous intéresser, si vous avez consenti à recevoir ces communications.\n• Vous fournir un service client et répondre à vos demandes.",
              style: TextStyle(fontFamily: 'Raleway', fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '3. Partage des informations personnelles',
              style: TextStyle(fontFamily: 'Raleway', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Nous ne partagerons vos informations personnelles que dans les circonstances suivantes :\n• Prestataires de services tiers : Nous pouvons partager vos informations avec des prestataires de services (comme les services de paiement, de livraison ou d’hébergement) pour fournir nos services. Ces prestataires sont tenus de respecter la confidentialité de vos données et de les utiliser uniquement dans le cadre des services fournis.\n• Conformité légale : Nous pouvons être amenés à divulguer vos informations personnelles si la loi tunisienne l’exige, ou pour protéger nos droits, la sécurité de notre application et des utilisateurs, ou en cas de procédure judiciaire.",
              style: TextStyle(fontFamily: 'Raleway', fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '4. Protection des informations personnelles',
              style: TextStyle(fontFamily: 'Raleway', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Nous utilisons des mesures de sécurité appropriées pour protéger vos informations personnelles contre la perte, l’accès non autorisé, la divulgation, la modification ou la destruction. Cependant, bien qu’aucun système ne soit totalement invulnérable, nous mettons en œuvre toutes les précautions nécessaires pour assurer la sécurité de vos données.",
              style: TextStyle(fontFamily: 'Raleway', fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '9. Contact',
              style: TextStyle(fontFamily: 'Raleway', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Si vous avez des questions concernant cette politique de confidentialité ou si vous souhaitez exercer vos droits en matière de protection des données personnelles, vous pouvez nous contacter à l’adresse suivante : Finessetn1@gmail.com',
              style: TextStyle(fontFamily: 'Raleway', fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
