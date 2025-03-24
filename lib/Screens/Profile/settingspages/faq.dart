import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQ',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFAQItem(
              'Comment puis-je vendre un article sur l’application ?',
              'Pour vendre un article, il vous suffit de suivre ces étapes :\n\n- Créez un compte ou connectez-vous.\n- Cliquez sur “Vendre un article” dans le menu principal.\n- Ajoutez des photos de l’article, une description détaillée et le prix souhaité.\n- Publiez votre annonce, et elle sera visible pour tous les acheteurs intéressés !',
            ),
            _buildFAQItem(
              'Comment savoir si mon article a été vendu ?',
              'Vous recevrez une notification instantanée lorsque votre article est vendu. Vous pourrez aussi suivre l’état de vos ventes dans l’onglet “Mes Ventes”.',
            ),
            _buildFAQItem(
              'Comment se passe la livraison ?',
              'Une fois l’achat effectué, un livreur viendra récupérer votre article sous 24h. Vous recevrez un code de livraison à joindre à votre commande. L’article sera ensuite expédié, et vous serez informé de chaque étape via l’application.',
            ),
            _buildFAQItem(
              'Quels types d’articles puis-je vendre ?',
              'Vous pouvez vendre des œuvres d’art, des articles artisanaux, des pièces de décoration vintage, des vêtements et accessoires vintage, et tout autre objet unique ou original lié à ces catégories.',
            ),
            _buildFAQItem(
              'Comment puis-je savoir si un article est en stock ?',
              'Tous les articles en vente sur l’application sont immédiatement disponibles, sauf indication contraire dans la description du produit.',
            ),
            _buildFAQItem(
              'Est-ce que l’application prend une commission sur les ventes ?',
              'Oui, une commission de 20% est prélevée sur chaque vente pour couvrir les frais de gestion et de sécurité de la plateforme.',
            ),
            _buildFAQItem(
              'Puis-je annuler ma commande après l’achat ?',
              'Les annulations sont possibles uniquement si la commande n’a pas encore été expédiée. Sinon, vous devrez suivre notre politique de retour.',
            ),
            _buildFAQItem(
              'Quels sont les délais de livraison ?',
              'Une fois votre commande confirmée, vous recevrez l’article sous 48 heures. Le suivi de livraison sera disponible dans l’onglet “Mes Commandes”.',
            ),
            _buildFAQItem(
              'Quelle est votre politique de retour ?',
              'Nous proposons des retours gratuits sous certaines conditions :\n- L’article doit être dans son état d’origine, sans dommages.\n- Le retour doit être effectué dans les 14 jours suivant la réception.',
            ),
            _buildFAQItem(
              'Puis-je modifier mon annonce après l’avoir publiée ?',
              'Oui, vous pouvez modifier vos annonces à tout moment en accédant à “Mes Ventes”.',
            ),
            _buildFAQItem(
              'Que faire si un article présente un défaut ?',
              'Si vous remarquez un défaut sur un article acheté, contactez notre service client dans les 24h suivant la réception.',
            ),
            _buildFAQItem(
              'Comment contacter le service client ?',
              'Vous pouvez nous contacter via l’option “Support” dans l’application. Nous nous engageons à répondre dans les 24 heures.',
            ),
            _buildFAQItem(
              'Est-ce que mes informations personnelles sont sécurisées ?',
              'Oui, la sécurité de vos données est notre priorité. Toutes vos informations sont cryptées et protégées selon les normes les plus strictes.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              answer,
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
