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
            _buildSectionTitle('Chez Art Zi, nous nous engageons à protéger votre vie privée...'),
            _buildSectionTitle('1. Collecte des informations personnelles'),
            _buildParagraph('Nous collectons des informations personnelles vous concernant lorsque vous utilisez notre application mobile de dépôt-vente, y compris :'),
            _buildBulletPoint('Informations d’identification personnelle : Votre nom, adresse e-mail, numéro de téléphone, etc.'),
            _buildBulletPoint('Informations financières : Détails de votre carte bancaire ou services de paiement tiers.'),
            _buildBulletPoint('Données d’utilisation : Pages visitées, actions effectuées, articles ajoutés à votre panier, etc.'),
            _buildBulletPoint('Données liées à vos transactions : Historique des achats et ventes.'),
            _buildBulletPoint('Données de géolocalisation (si activée) pour la livraison des articles.'),
            
            _buildSectionTitle('2. Utilisation de vos informations personnelles'),
            _buildBulletPoint('Fournir nos services et traiter vos achats.'),
            _buildBulletPoint('Personnaliser votre expérience utilisateur.'),
            _buildBulletPoint('Envoyer des notifications relatives à votre compte et vos commandes.'),
            _buildBulletPoint('Informer des nouvelles offres et promotions (avec votre consentement).'),
            _buildBulletPoint('Fournir un service client.'),
            
            _buildSectionTitle('3. Partage des informations personnelles'),
            _buildParagraph('Nous partageons vos informations uniquement avec :'),
            _buildBulletPoint('Prestataires de services tiers (paiement, livraison, hébergement).'),
            _buildBulletPoint('Conformité légale : Si la loi l’exige ou pour protéger nos droits et la sécurité des utilisateurs.'),
            
            _buildSectionTitle('4. Protection des informations personnelles'),
            _buildParagraph('Nous utilisons des mesures de sécurité pour protéger vos informations contre l’accès non autorisé, la divulgation ou la modification.'),
            
            _buildSectionTitle('5. Vos droits'),
            _buildBulletPoint('Droit d’accès : Demander une copie des informations détenues.'),
            _buildBulletPoint('Droit de rectification : Modifier des informations incorrectes.'),
            _buildBulletPoint('Droit d’effacement : Supprimer vos données sous certaines conditions.'),
            _buildBulletPoint('Droit d’opposition : Refuser le traitement de vos données à des fins marketing.'),
            _buildBulletPoint('Droit de portabilité : Recevoir vos données dans un format structuré.'),
            _buildParagraph('Pour exercer ces droits, contactez-nous à : Finessetn1@gmail.com'),
            
            _buildSectionTitle('6. Conservation des données'),
            _buildParagraph('Vos données sont conservées tant que nécessaire pour fournir nos services et respecter les obligations légales. Ensuite, elles sont supprimées ou anonymisées.'),
            
            _buildSectionTitle('7. Cookies et technologies similaires'),
            _buildParagraph('Nous utilisons des cookies pour améliorer votre expérience. Vous pouvez les désactiver, mais cela peut affecter l’expérience utilisateur.'),
            
            _buildSectionTitle('8. Modifications de la politique de confidentialité'),
            _buildParagraph('Nous nous réservons le droit de modifier cette politique. Les changements seront communiqués via l’application.'),
            
            _buildSectionTitle('9. Contact'),
            _buildParagraph('Si vous avez des questions, contactez-nous à : Finessetn1@gmail.com'),
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
        style: TextStyle(fontFamily: "Raleway",fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontFamily: "Raleway",fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontFamily: "Raleway",fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16,fontFamily: "Raleway" ,color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
