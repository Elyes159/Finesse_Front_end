import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Politique de Confidentialité'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
                'Chez Art Zi, nous nous engageons à protéger votre vie privée et à respecter les lois et régulations en vigueur en Tunisie concernant la protection des données personnelles. Cette politique de confidentialité explique comment nous collectons, utilisons, protégeons et partageons vos informations personnelles lorsque vous utilisez notre application mobile.'),
            _buildSectionTitle('1. Collecte des informations personnelles'),
            _buildParagraph(
                'Nous collectons des informations personnelles vous concernant lorsque vous utilisez notre application mobile de dépôt-vente, y compris :'),
            _buildBulletPoint(
                'Informations d’identification personnelle : Votre nom, adresse e-mail, numéro de téléphone, adresse physique, etc.'),
            _buildBulletPoint(
                'Informations financières : Détails de votre carte bancaire ou informations relatives aux services de paiement tiers utilisés pour vos transactions.'),
            _buildBulletPoint(
                'Données d’utilisation : Nous collectons des informations sur l’utilisation de notre application (pages visitées, actions effectuées, articles ajoutés à votre panier, etc.).'),
            _buildBulletPoint(
                'Données liées à vos transactions : Historique des achats et ventes effectuées sur notre plateforme, ainsi que des informations sur la livraison et l’expédition.'),
            _buildBulletPoint(
                'Données de géolocalisation (si vous l’activez) : Nous pouvons collecter votre localisation pour faciliter la livraison de vos articles.'),
            _buildSectionTitle(
                '2. Utilisation de vos informations personnelles'),
            _buildBulletPoint(
                'Fournir nos services et produits, traiter vos achats, gérer vos ventes, et assurer la livraison de vos articles.'),
            _buildBulletPoint(
                'Personnaliser votre expérience utilisateur et améliorer nos services.'),
            _buildBulletPoint(
                'Vous envoyer des notifications relatives à votre compte, vos commandes ou toute autre activité liée à l’application.'),
            _buildBulletPoint(
                'Vous informer de nouvelles offres, promotions, et autres informations susceptibles de vous intéresser, si vous avez consenti à recevoir ces communications.'),
            _buildBulletPoint(
                'Vous fournir un service client et répondre à vos demandes.'),
            _buildSectionTitle('3. Partage des informations personnelles'),
            _buildParagraph(
                'Nous ne partagerons vos informations personnelles que dans les circonstances suivantes :'),
            _buildBulletPoint(
                'Prestataires de services tiers : Nous pouvons partager vos informations avec des prestataires de services (comme les services de paiement, de livraison ou d’hébergement) pour fournir nos services. Ces prestataires sont tenus de respecter la confidentialité de vos données et de les utiliser uniquement dans le cadre des services fournis.'),
            _buildBulletPoint(
                'Conformité légale : Nous pouvons être amenés à divulguer vos informations personnelles si la loi tunisienne l’exige, ou pour protéger nos droits, la sécurité de notre application et des utilisateurs, ou en cas de procédure judiciaire.'),
            _buildSectionTitle('4. Protection des informations personnelles'),
            _buildParagraph(
                'Nous utilisons des mesures de sécurité appropriées pour protéger vos informations personnelles contre la perte, l’accès non autorisé, la divulgation, la modification ou la destruction. Cependant, bien qu’aucun système ne soit totalement invulnérable, nous mettons en œuvre toutes les précautions nécessaires pour assurer la sécurité de vos données.'),
            _buildSectionTitle('5. Vos droits'),
            _buildBulletPoint(
                'Droit d’accès : Vous pouvez demander une copie des informations personnelles que nous détenons à votre sujet.'),
            _buildBulletPoint(
                'Droit de rectification : Si vous constatez que certaines de vos informations sont inexactes ou incomplètes, vous pouvez demander leur modification.'),
            _buildBulletPoint(
                'Droit d’effacement : Vous pouvez demander la suppression de vos informations personnelles, sauf si elles sont nécessaires pour des raisons légales ou contractuelles.'),
            _buildBulletPoint(
                'Droit d’opposition : Vous pouvez vous opposer au traitement de vos informations personnelles à des fins de marketing ou autres finalités légitimes.'),
            _buildBulletPoint(
                'Droit de portabilité : Vous pouvez demander à recevoir vos données personnelles dans un format structuré, couramment utilisé et lisible par machine, ou à les transmettre à un autre responsable du traitement.'),
            _buildParagraph(
                'Pour exercer ces droits, veuillez nous contacter à l’adresse suivante : Finessetn1@gmail.com'),
            _buildSectionTitle('6. Conservation des données'),
            _buildParagraph(
                'Nous conservons vos informations personnelles aussi longtemps que nécessaire pour vous fournir nos services, respecter nos obligations légales et résoudre les différends. Lorsque vos informations ne sont plus nécessaires, elles seront supprimées ou anonymisées.'),
            _buildSectionTitle('7. Cookies et technologies similaires'),
            _buildParagraph(
                'Nous utilisons des cookies et des technologies similaires pour améliorer votre expérience sur notre application, comme la personnalisation de votre contenu ou la mémorisation de vos préférences de navigation. Vous pouvez désactiver les cookies dans les paramètres de votre appareil ou de l’application, bien que cela puisse affecter votre expérience utilisateur.'),
            _buildSectionTitle(
                '8. Modifications de la politique de confidentialité'),
            _buildParagraph(
                'Nous nous réservons le droit de modifier cette politique de confidentialité à tout moment. Nous vous informerons de tout changement en publiant une version mise à jour dans l’application et en mettant à jour la date de révision. Il est de votre responsabilité de consulter régulièrement cette politique pour prendre connaissance de toute modification.'),
            _buildSectionTitle('9. Contact'),
            _buildParagraph(
                'Si vous avez des questions concernant cette politique de confidentialité ou si vous souhaitez exercer vos droits en matière de protection des données personnelles, vous pouvez nous contacter à l’adresse suivante : Finessetn1@gmail.com'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontFamily: "Raleway",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: "Raleway", fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ',
              style: TextStyle(
                  fontFamily: "Raleway",
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16, fontFamily: "Raleway", color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
