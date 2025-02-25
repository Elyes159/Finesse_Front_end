import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customfieldbuton.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Text(
                  'recherche',
                  style: TextStyle(
                    color: Color(0xFF111928),
                    fontSize: 16,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
            ),
          ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomTextFormFieldwithButton(
              controller: searchController,
              label: 'Rechercher un produit...',
              isPassword: false,
              onButtonPressed: () {},
            ),
          ),
          Expanded(
            child: Consumer<Products>(
              builder: (context, productsProvider, child) {
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: productsProvider.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = productsProvider.filteredProducts[index];
                    return ProductCard(
                      imageUrl: product['images'].isNotEmpty
                          ? "${AppConfig.baseUrl}${product['images'][0]}"
                          : 'assets/default_image.png',
                      productName: product['title'],
                      productPrice: '${product['price']} millimes',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}