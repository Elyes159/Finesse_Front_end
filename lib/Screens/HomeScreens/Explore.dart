import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Screens/SellProduct/itemDetails.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    Provider.of<Products>(context, listen: false)
        .filterProducts(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Text(
              'Recherche',
              style: TextStyle(
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
              controller: _searchController,
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
                    final productData = {
                      'type': 'Pour vous',
                      'category': product['category'] ?? 'Unknown',
                      'subcategory': product['subcategory'] ?? 'Unknown',
                      'imageUrl': product['images'].isNotEmpty
                          ? "${AppConfig.baseUrl}${product['images'][0]}"
                          : 'assets/default_image.png',
                      'images': product['images'] ?? [],
                      'productName': product['title'] ?? 'Unknown Product',
                      'productPrice': "${product['price']} TND",
                      'product_id': "${product['id']}",
                      'description': product['description'] ?? '',
                      'is_available': product['is_available'] ?? false,
                      'taille': product['taille'],
                      'is_favorite': product['is_favorite'],
                      'pointure': product['pointure'],
                      'selled': product["selled"],
                      'brand': product['brand'],
                      'owner_id': product["owner"]["id"],
                      'type_pdp': product["type"],
                      'owner_profile_pic': product["owner"]["profile_pic"] ?? "",
                      'owner_username': product["owner"]["username"] ?? "",
                      'owner_ratings': product["owner"]["ratings"] ?? "",
                      'comments': product['comments']?.map((comment) => {
                            'username': comment['username'] ?? 'Unknown',
                            'avatar': comment['avatar'] ?? '',
                            'content': comment['content'] ?? '',
                            'created_at': comment['created_at'] ?? '',
                          }).toList() ?? [],
                    };
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemDetails(product: productData)));
                      },
                      child: ProductCard(
                        imageUrl: product['images'].isNotEmpty
                            ? "${AppConfig.baseUrl}${product['images'][0]}"
                            : 'assets/default_image.png',
                        productName: product['title'] ?? 'Produit inconnu',
                        productPrice: '${product['price'] ?? 'Prix inconnu'} TND',
                      ),
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