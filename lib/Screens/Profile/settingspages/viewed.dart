import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Viewed extends StatefulWidget {
  const Viewed({super.key});

  @override
  State<Viewed> createState() => _ViewedState();
}

class _ViewedState extends State<Viewed> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Products>(
      builder: (context, provider, child) {
        final viewedProducts =
            provider.productsView; // Accédez à la liste des produits vus

        return Scaffold(
          appBar: AppBar(
              title: Text(
            'Vu récemment',
            style: TextStyle(
              //color: Colors.black,
              fontSize: 16,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
              height: 1.50,
              letterSpacing: 0.50,
            ),
          )),
          body: viewedProducts.isEmpty
              ? const Center(
                  child: Text(
                  'Aucun produit vu.',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.40,
                  ),
                  textAlign: TextAlign.center,
                ))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Deux colonnes
                    childAspectRatio:
                        0.8, // Ratio largeur/hauteur pour les cartes
                    crossAxisSpacing: 8, // Espacement horizontal
                    mainAxisSpacing: 8, // Espacement vertical
                  ),
                  padding: const EdgeInsets.all(0.0),
                  itemCount: viewedProducts.length,
                  itemBuilder: (context, index) {
                    final product = viewedProducts[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProductCard(
                        imageUrl:
                            "${AppConfig.baseUrl}${product["images"][0]}", // Assurez-vous que la clé correspond à votre modèle
                        productName: product[
                            'title'], // Assurez-vous que la clé correspond à votre modèle
                        productPrice: product['price']
                            .toString(), // Assurez-vous que la clé correspond à votre modèle
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
