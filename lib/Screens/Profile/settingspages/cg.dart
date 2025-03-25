import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conditions Générales d’Utilisation'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
                "Art Zi – Application mobile de dépôt-vente d’art, artisanat et vintage"),
            _buildSectionSubtitle("Dernière mise à jour : 24 Mars 2025"),
            _buildSectionTitle("1. Objet"),
            _buildSectionText(
                "Les présentes Conditions Générales d’Utilisation (CGU) ont pour objet de définir les conditions d’utilisation de l’application mobile Art Zi, un service de dépôt-vente en ligne pour l’art, l’artisanat et le vintage, accessible sur les plateformes mobiles. En utilisant l’application Art Zi, vous acceptez de manière pleine et entière ces conditions."),
            _buildSectionTitle("2. Accès à l’application"),
            _buildSectionText(
                "L’application Art Zi est accessible gratuitement, sous réserve de disposer d’une connexion Internet et d’un appareil compatible. L’application est disponible sur les systèmes Android et iOS. L’utilisation de l’application nécessite la création d’un compte utilisateur."),
            _buildSectionTitle("3. Services fournis"),
            _buildSectionText("L’application Art Zi permet aux utilisateurs de :"),
            _buildBulletPoints([
              "Vendre des articles : Les utilisateurs peuvent déposer leurs articles à vendre (art, artisanat, mode, vintage) en fournissant des informations détaillées sur chaque produit, telles que la description, le prix, et des photos.",
              "Acheter des articles : Les utilisateurs peuvent consulter les articles mis en vente, effectuer des achats et noter le vendeur.",
              "Communiquer : Les utilisateurs peuvent échanger avec les vendeurs via les commentaires dans l’application pour poser des questions sur les articles ou discuter des conditions de vente."
            ]),
            _buildSectionTitle("4. Inscription et création de compte"),
            _buildSectionText(
                "Pour accéder aux services de l’application Art Zi, l’utilisateur doit créer un compte en fournissant des informations personnelles exactes et à jour (nom, adresse e-mail, numéro de téléphone, etc.). L’utilisateur est responsable de la confidentialité de ses identifiants de connexion et s’engage à ne pas les partager avec des tiers."),
            _buildSectionTitle("5. Conditions de vente"),
            _buildBulletPoints([
              "Vendeur : En tant que vendeur, vous êtes responsable de la description de vos articles, de leur prix et de leur conformité avec la législation en vigueur en Tunisie. Vous vous engagez à vendre des produits légaux et à ne pas proposer des articles contrefaits ou illégaux.",
              "Acheteur : L’acheteur est responsable du paiement des articles achetés et de la vérification de la qualité des articles lors de la réception."
            ]),
            _buildSectionTitle("6. Prix et paiements"),
            _buildSectionText(
                "Les prix des articles sont déterminés par les vendeurs. Art Zi prend une commission sur les transactions effectuées, sauf indication contraire. Le paiement des articles achetés doit être effectué via les moyens de paiement sécurisés mis à disposition dans l’application."),
            _buildSectionTitle("7. Propriété intellectuelle"),
            _buildSectionText(
                "Tous les contenus présents dans l’application Art Zi, tels que les textes, images, logos, graphismes, et autres éléments sont protégés par les droits de propriété intellectuelle. Toute reproduction, représentation ou exploitation de ces contenus est interdite sans autorisation préalable."),
            _buildSectionTitle("8. Responsabilité"),
            _buildBulletPoints([
              "Responsabilité des utilisateurs : L’utilisateur s’engage à utiliser l’application de manière responsable et à respecter la législation en vigueur. Art Zi ne saurait être tenu responsable des transactions entre utilisateurs, des articles défectueux ou non conformes.",
              "Responsabilité de Art Zi : L’application Art Zi s’efforce de garantir la disponibilité de ses services, mais ne peut être responsable en cas de dysfonctionnement technique, de perte de données ou d’autres événements échappant à son contrôle."
            ]),
            _buildSectionTitle("9. Données personnelles"),
            _buildSectionText(
                "Art Zi collecte et traite les données personnelles des utilisateurs conformément à sa politique de confidentialité. Ces données sont utilisées pour gérer votre compte, traiter vos commandes et améliorer l’expérience utilisateur. Les informations personnelles ne sont pas partagées avec des tiers, sauf en cas de nécessité pour la bonne exécution des services ou en réponse à une obligation légale."),
            _buildSectionTitle("10. Modification des CGU"),
            _buildSectionText(
                "Art Zi se réserve le droit de modifier ces Conditions Générales d’Utilisation à tout moment. En cas de modification substantielle, les utilisateurs seront informés via l’application. L’utilisation continue de l’application après modification des CGU constitue une acceptation des nouvelles conditions."),
            _buildSectionTitle("11. Résiliation et suspension du compte"),
            _buildSectionText(
                "Art Zi se réserve le droit de suspendre ou de résilier l’accès à l’application pour toute violation des présentes CGU, ou pour toute activité illégale, frauduleuse ou abusive détectée."),
            _buildSectionTitle("12. Durée et résiliation"),
            _buildSectionText(
                "Les présentes CGU sont en vigueur tant que l’utilisateur utilise l’application. L’utilisateur peut résilier son compte à tout moment via les paramètres de l’application. Art Zi se réserve le droit de suspendre ou de supprimer tout compte en cas de violation des présentes conditions."),
            _buildSectionTitle("13. Loi applicable et litiges"),
            _buildSectionText(
                "Les présentes Conditions Générales d’Utilisation sont régies par la législation en vigueur en Tunisie. En cas de litige, les parties conviennent de tenter une résolution amiable. Si aucune solution amiable n’est trouvée, le litige sera soumis aux juridictions compétentes de Tunisie."),
            _buildSectionTitle("14. Contact"),
            _buildSectionText(
                "Pour toute question ou réclamation concernant ces Conditions Générales d’Utilisation, vous pouvez nous contacter à l’adresse suivante :"),
            _buildSectionText("Email : finessetn1@gmail.com", isBold: true),
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
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildSectionSubtitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        subtitle,
        style: TextStyle(
            fontFamily: "Raleway",
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildSectionText(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: "Raleway",
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points
          .map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• ",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(fontFamily: "Raleway", fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
