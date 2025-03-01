import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Provider/profileProvider.dart';
import 'package:finesse_frontend/Screens/Profile/ProfileScreen.dart';
import 'package:finesse_frontend/Screens/SellProduct/categories.dart';
import 'package:finesse_frontend/Screens/SellProduct/itemDetails.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customfieldbuton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/search.dart';
import 'package:finesse_frontend/Widgets/cards/productCard.dart';
import 'package:finesse_frontend/Widgets/categorieChip/categoryChip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String? from_mv;
  const Explore({super.key, this.from_mv});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String _searchType = 'article'; // Par défaut, rechercher un article

 @override
void initState() {
  super.initState();

  // Récupération des produits au démarrage
  Provider.of<Products>(context, listen: false).fetchMembers(
      Provider.of<AuthService>(context, listen: false).currentUser!.id);
  
  _searchController.addListener(_onSearchChanged);

  // Vérifier si `from_mv` est défini et appliquer le filtre
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (widget.from_mv != null && widget.from_mv!.isNotEmpty) {
      final productsProvider = Provider.of<Products>(context, listen: false);
      _categoryController.text = widget.from_mv!;
      productsProvider.filterProductsByCategory(widget.from_mv!);
    }
  });
}


  void _onSearchChanged() {
    if (_searchType == 'membre') {
      Provider.of<Products>(context, listen: false)
          .filterMembers(_searchController.text);
    }
    Provider.of<Products>(context, listen: false)
        .filterProducts(_searchController.text, _searchType);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: DropdownButton<String>(
                      underline: const SizedBox.shrink(),
                      value: _searchType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _searchType = newValue!;
                        });
                        _onSearchChanged(); // Refiltrer les produits/membres après le changement
                      },
                      items: <String>['article', 'membre']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value == 'article' ? 'Produit' : 'Membre',
                              style: TextStyle(fontFamily: "Raleway")),
                        );
                      }).toList(),
                    ),
                  ),

                  // Espace d'écriture pour la recherche
                  Expanded(
                    child: SearchBarF(
                      controller: _searchController,
                      label: 'Rechercher...',
                      isPassword: false,
                      onButtonPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<Products>(
              builder: (context, productsProvider, child) {
                if (_searchType == 'article') {
                  String selectedCategory = "All";
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Ajoute ici l'action à exécuter lors du clic
                          final selectedCategory = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChooseCategory(isExplore: true),
                            ),
                          );
                          print("3Aaaas&aaa");
                          if (selectedCategory != null &&
                              selectedCategory['explore'] != null) {
                            setState(() {
                              _categoryController.text =
                                  selectedCategory['explore'];
                            });

                            productsProvider.filterProductsByCategory(
                                selectedCategory['explore'] ?? widget.from_mv);
                          }
                        },
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            label: 'Catégorie',
                            isPassword: false,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'La catégorie est obligatoire';
                              }
                              return null;
                            },
                            controller: _categoryController,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: productsProvider.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product =
                                productsProvider.filteredProducts[index];
                            final productData = {
                              'type': 'Pour vous',
                              'category': product['category'] ?? 'Unknown',
                              'subcategory':
                                  product['subcategory'] ?? 'Unknown',
                              'imageUrl': product['images'].isNotEmpty
                                  ? "${AppConfig.baseUrl}${product['images'][0]}"
                                  : 'assets/default_image.png',
                              'images': product['images'] ?? [],
                              'productName':
                                  product['title'] ?? 'Unknown Product',
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
                              'owner_profile_pic':
                                  product["owner"]["profile_pic"] ?? "",
                              'owner_username':
                                  product["owner"]["username"] ?? "",
                              'owner_ratings':
                                  product["owner"]["ratings"] ?? "",
                              'comments': product['comments']
                                      ?.map((comment) => {
                                            'username': comment['username'] ??
                                                'Unknown',
                                            'avatar': comment['avatar'] ?? '',
                                            'content': comment['content'] ?? '',
                                            'created_at':
                                                comment['created_at'] ?? '',
                                          })
                                      .toList() ??
                                  [],
                            };
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ItemDetails(product: productData)));
                              },
                              child: ProductCard(
                                imageUrl: product['images'].isNotEmpty
                                    ? "${AppConfig.baseUrl}${product['images'][0]}"
                                    : 'assets/default_image.png',
                                productName:
                                    product['title'] ?? 'Produit inconnu',
                                productPrice:
                                    '${product['price'] ?? 'Prix inconnu'} TND',
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                // Afficher les membres si "membre" est sélectionné
                else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: productsProvider.filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = productsProvider.filteredMembers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              member["image_type"] == "normal"
                                  ? "${AppConfig.baseUrl}${member['avatar']}"
                                  : member["avatar"]),
                        ),
                        title: Text(
                          member['full_name'] ?? 'Nom Inconnu',
                          style: TextStyle(fontFamily: "Raleway"),
                        ),
                        subtitle: Text(
                          'Rating: ${member['average_rating'] != null ? (member['average_rating'] as double).toStringAsFixed(2) + ' ★' : 'N/A'}',
                          style: TextStyle(fontFamily: "Raleway"),
                        ),
                        onTap: () async {
                          // Navigation vers le profil du membre
                          await Provider.of<Profileprovider>(context,
                                  listen: false)
                              .fetchProfile(member["id"]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfileMain(id: member["id"])),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
