import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Annonce extends StatefulWidget {
  const Annonce({super.key});

  @override
  State<Annonce> createState() => _AnnonceState();
}

class _AnnonceState extends State<Annonce> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Products>(
      builder: (context, productsProvider, child) {
        final productsByUser = productsProvider.productsByUser;
        print("Produits récupérés : $productsByUser");

        // Séparation des produits en catégories
        final refusedProducts = productsByUser
            .where((product) => product["is_refused"] == true)
            .toList();
        final validatedProducts = productsByUser
            .where((product) => product["validated"] == true)
            .toList();
        final pendingProducts = productsByUser
            .where((product) =>
                product["is_refused"] == false && product["validated"] == false)
            .toList();

        return Scaffold(
          appBar: AppBar(
              title: const Text(
            "Mes Annonces",
            style: TextStyle(
              //color: Color(0xFF111928),
              fontSize: 16,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
              height: 1.25,
              letterSpacing: 0.50,
            ),
          )),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection("Validés", validatedProducts),
                  _buildSection("Refusés", refusedProducts),
                  _buildSection("En attente", pendingProducts),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<dynamic> products) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
      ),
      trailing: const Icon(Icons.arrow_drop_down), // Flèche
      children: [
        if (products.isNotEmpty) _buildProductList(products),
        if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Aucun produit disponible.",
                style: TextStyle(color: Colors.grey, fontFamily: 'Raleway')),
          ),
      ],
    );
  }

  Widget _buildProductList(List<dynamic> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 colonnes
        crossAxisSpacing: 12.0, // Espace horizontal entre les éléments
        mainAxisSpacing: 12.0, // Espace vertical entre les éléments
        childAspectRatio:
            0.75, // Ratio de la taille des éléments (largeur/hauteur)
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          imageUrl: "${AppConfig.baseUrl}/${product["images"][0]}",
          productName: product["title"] ?? "Nom inconnu",
          productPrice: "${product["price"] ?? 0} €",
        );
      },
    );
  }
}
