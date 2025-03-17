import 'dart:convert';
import 'dart:io';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class Products extends ChangeNotifier {
  final storage = FlutterSecureStorage();
  String? errorMessage;
  int? nbfollowers;
  int? nbfollowervisited;
  late List products = [];
  late List productsView = [];
  late List productsArt = [];
  late List followers = [];
  late List followersvisited = [];
  late List Ratings = [];
  late List RatingsVisited = [];
  late List productsByUser = [];
  late List productsSelledByUser = [];
  late List productsByUserVisited = [];
  late List productsSelledByUserVisited = [];

  double? avarageRate;
  int? countRate;
  late double ratingPercentage1 = 0;
  late double ratingPercentage2 = 0;
  late double ratingPercentage3 = 0;
  late double ratingPercentage4 = 0;
  late double ratingPercentage5 = 50;
  double? avarageRateVisited;
  int? countRateVisited;
  late double ratingPercentage1Visited = 0;
  late double ratingPercentage2Visited = 0;
  late double ratingPercentage3Visited = 0;
  late double ratingPercentage4Visited = 0;
  late double ratingPercentage5Visited = 50;
  List<dynamic> favoriteProducts = [];
  List<dynamic> wishProducts = [];
  bool? canRate;
  List filteredProducts = [];
  String? _promoCode;
  double? _discount;
  String? _errorMessage;

  String? get promoCode => _promoCode;
  double? get discount => _discount;

  Future<bool> checkPromoCode(String code) async {
    final url =
        Uri.parse("${AppConfig.baseUrl}/api/products/check_promo_code/$code/");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _promoCode = data["code"];
        _discount = data["discount"];
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = "Code promo invalide.";
        _promoCode = null;
        _discount = null;
        return false;
      }
    } catch (error) {
      _errorMessage = "Erreur de connexion.";
      _promoCode = null;
      _discount = null;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sellProduct(
      String title,
      String description,
      String subCatgory,
      double price,
      String possibleDeff,
      String? taille,
      String? pointure,
      String? etat,
      String? brand,
      String? dimension,
      List<File?> images,
      String? hauteur,
      String? largeur,
      String? longeur,) async {
    // Vérification de la validité de l'ID utilisateur
    String? storedUserId = await storage.read(key: 'user_id');
    if (storedUserId == null || storedUserId.isEmpty) {
      print("Erreur: L'ID utilisateur est manquant.");
      return false;
    }

    final url = Uri.parse("${AppConfig.baseUrl}/api/products/createProduct/");
    var request = http.MultipartRequest('POST', url);

    request.fields['owner_id'] = storedUserId;
    request.fields['category_id'] = subCatgory;
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['taille'] = taille ?? "";
    request.fields['pointure'] = pointure ?? "0";
    request.fields['etat'] = etat ?? "";
    request.fields['brand'] = brand ?? "";
    request.fields['longeur'] = longeur ?? "";
    request.fields['largeur'] = largeur ?? "";
    request.fields['hauteur'] = hauteur ?? "";
    request.fields['is_available'] = "true"; // Défini comme "true"

    // Ajouter les images à la requête
    for (var image in images) {
      if (image != null) {
        try {
          // Vérification que l'image existe bien et est lisible
          if (!await image.exists()) {
            print("Erreur: L'image ${image.uri.path} n'existe pas.");
            continue;
          }

          // Détecter le type MIME de l'image
          String? mimeType = lookupMimeType(image.uri.path);
          String mimeTypePart =
              mimeType?.split('/')[1] ?? 'jpeg'; // Type MIME par défaut
          print("Type MIME détecté : $mimeTypePart");

          var imageStream = http.ByteStream(image.openRead());
          var imageLength = await image.length();
          var multipartFile = http.MultipartFile(
            'images',
            imageStream,
            imageLength,
            filename: image.uri.pathSegments.last,
            contentType: MediaType('image', mimeTypePart),
          );
          request.files.add(multipartFile);
        } catch (e) {
          print("Erreur lors de l'ajout de l'image : $e");
          return false;
        }
      }
    }

    print("Données envoyées : ");
    print("Owner ID: $storedUserId");
    print("Category ID: $subCatgory");
    print("Title: $title");
    print("Description: $description");
    print("Price: $price");
    print("Taille: $taille");
    print("Pointure: $pointure");

    try {
      var response = await request.send();
      final responseString = await response.stream.bytesToString();
      print("Réponse du serveur : $responseString");

      // Vérifier le code de statut de la réponse
      if (response.statusCode == 201) {
        notifyListeners(); // Notifier les auditeurs
        return true;
      } else {
        final Map<String, dynamic> responseJson = json.decode(responseString);

        errorMessage = responseJson["message"];
        print("Erreur serveur: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Erreur lors de l'envoi de la requête : $e");
      return false; // Retourner false si une exception se produit lors de l'envoi
    }
  }

  Future<http.StreamedResponse> updateProduct(
      String productId,
      String title,
      String description,
      String subCategory,
      double price,
      String possibleDeff,
      String? taille,
      String? pointure,
      String? etat,
      String? brand,
      List<File?> images) async {
    // Vérification de la validité de l'ID utilisateur
    String? storedUserId = await storage.read(key: 'user_id');
    if (storedUserId == null || storedUserId.isEmpty) {
      throw Exception("Erreur: L'ID utilisateur est manquant.");
    }

    final url = Uri.parse("${AppConfig.baseUrl}/api/products/updateProduct/");
    var request = http.MultipartRequest('POST', url);

    request.fields['owner_id'] = storedUserId;
    request.fields['product_id'] = productId;
    request.fields['category_id'] = subCategory;
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['taille'] = taille ?? "";
    request.fields['pointure'] = pointure ?? "0";
    request.fields['etat'] = etat ?? "";
    request.fields['brand'] = brand ?? "";
    request.fields['is_available'] = "true"; // Défini comme "true"

    // Ajouter les images à la requête
    for (var image in images) {
      if (image != null) {
        try {
          if (!await image.exists()) {
            throw Exception("Erreur: L'image ${image.uri.path} n'existe pas.");
          }

          String? mimeType = lookupMimeType(image.uri.path);
          String mimeTypePart =
              mimeType?.split('/')[1] ?? 'jpeg'; // Par défaut : jpeg

          var imageStream = http.ByteStream(image.openRead());
          var imageLength = await image.length();
          var multipartFile = http.MultipartFile(
            'images',
            imageStream,
            imageLength,
            filename: image.uri.pathSegments.last,
            contentType: MediaType('image', mimeTypePart),
          );
          request.files.add(multipartFile);
        } catch (e) {
          throw Exception("Erreur lors de l'ajout de l'image : $e");
        }
      }
    }

    try {
      var response = await request.send();
      return response; // Retourne directement la réponse HTTP
    } catch (e) {
      throw Exception("Erreur lors de l'envoi de la requête : $e");
    }
  }

  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> get members => _members;

  Future<void> fetchMembers(int userId) async {
    final url =
        '${AppConfig.baseUrl}/api/auth/fatchmembers/$userId'; // Remplacez par votre URL d'API

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _members = List<Map<String, dynamic>>.from(data['members']);
        _errorMessage = '';
      } else if (response.statusCode == 404) {
        _errorMessage = 'Utilisateur non trouvé.';
        _members = [];
      } else {
        _errorMessage = 'Une erreur est survenue. Code: ${response.statusCode}';
        _members = [];
      }
    } catch (error) {
      _errorMessage = 'Impossible de récupérer les membres: $error';
      _members = [];
    }

    notifyListeners();
  }

  List<Map<String, dynamic>> _filteredMembers = [];

  List<Map<String, dynamic>> get filteredMembers => _filteredMembers;
  void filterMembers(String searchText) {
    _filteredMembers = _members.where((member) {
      String fullName =
          member['full_name'] ?? ''; // Remplace null par une chaîne vide
      String query = searchText; // Assure que searchText n'est pas null

      return fullName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    notifyListeners();
  }

  Future<void> getProductsByUser() async {
    try {
      String? storedUserId = await storage.read(key: 'user_id');
      final url = Uri.parse(
          '${AppConfig.baseUrl}/api/products/getProductsByUser/$storedUserId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] != null) {
          productsByUser = data['products'];
          print(productsByUser);
          print(
              "OIHAEFOHAOFHPDJZAPOJZPOADJZOPJDZPAOJDZAPOJDPZAOJDPZAOJDPOZAJDPZOAJDPZOAJDPZOAJDZOPAJDOZPAJDOZAPJDOPZAJDZA");
          for (var product in products) {
            print('Produit : ${product['title']}');
            print('Description : ${product['description']}');
            print('Prix : ${product['price']}');
            print('Images : ${product['images']}');
            print(product["is_refused"]);
            print(product["validated"]);
          }
          notifyListeners();
        } else {
          print('Aucun produit trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<void> getProductsSelledByUser() async {
    try {
      String? storedUserId = await storage.read(key: 'user_id');
      final url = Uri.parse(
          '${AppConfig.baseUrl}/api/products/getProductsSelledByUser/$storedUserId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] != null) {
          productsSelledByUser = data['products'];
          print(productsSelledByUser);

          notifyListeners();
        } else {
          print('Aucun produit trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<void> getProductsSelledByUserVisited(int storedUserId) async {
    try {
      final url = Uri.parse(
          '${AppConfig.baseUrl}/api/products/getProductsSelledByUser/$storedUserId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] != null) {
          productsSelledByUserVisited = data['products'];
          print(productsSelledByUser);

          notifyListeners();
        } else {
          print('Aucun produit trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<void> getProductsByUserVisited(int storedUserId) async {
    try {
      final url = Uri.parse(
          '${AppConfig.baseUrl}/api/products/getProductsByUser/$storedUserId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] != null) {
          productsByUserVisited = data['products'];
          for (var product in products) {
            print('Produit : ${product['title']}');
            print('Description : ${product['description']}');
            print('Prix : ${product['price']}');
            print('Images : ${product['images']}');
          }
          notifyListeners();
        } else {
          print('Aucun produit trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<void> getProducts() async {
    try {
      String? storedUserId = await storage.read(key: 'user_id');
      final url = Uri.parse('${AppConfig.baseUrl}/api/products/getProducts/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] != null) {
          products = data['products'];
          filteredProducts = List.from(products); // Ajout de cette ligne

          for (var product in products) {
            print("category : ${product["category"]}");
            print("subcategory : ${product["subcategory"]}");
            print('Produit : ${product['title']}');
            print('Description : ${product['description']}');
            print('Prix : ${product['price']}');
            print('Images : ${product['images']}');
          }
          notifyListeners();
          print("hoooouuuni");
          print(products);
        } else {
          print('Aucun produit trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  void filterProductsByCategory(String category) {
    print("Catégorie sélectionnée: $category");
    print("Catégories disponibles dans les produits:");

    for (var product in products) {
      print(product['categoryForSearch']);
    }

    filteredProducts = products.where((product) {
      var categoryData = product['categoryForSearch'];
      if (categoryData is List) {
        return categoryData
            .contains(category); // Vérifie si la liste contient la catégorie
      } else {
        return categoryData ==
            category; // Vérifie si c'est une simple chaîne de caractères
      }
    }).toList();

    print("Produits trouvés après filtrage: ${filteredProducts.length}");
    notifyListeners();
  }

  Future<void> getProductsart() async {
    try {
      String? storedUserId = await storage.read(key: 'user_id');
      final url =
          Uri.parse('${AppConfig.baseUrl}/api/products/getProductsart/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] != null) {
          productsArt = data['products'];
          filteredProducts = List.from(products); // Ajout de cette ligne

          for (var product in products) {
            print("category : ${product["category"]}");
            print("subcategory : ${product["subcategory"]}");
            print('Produit : ${product['title']}');
            print('Description : ${product['description']}');
            print('Prix : ${product['price']}');
            print('Images : ${product['images']}');
          }
          notifyListeners();
          print("hoooouuuni");
          print(products);
        } else {
          print('Aucun produit trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  void filterProducts(String query, String searchType) {
    if (query.isEmpty) {
      filteredProducts = List.from(products);
    } else {
      filteredProducts = products
          .where((product) => product['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    print(
        "Produits filtrés : ${filteredProducts.length}"); // Ajout de cette ligne
    notifyListeners();
  }

  Future<void> getProductsViewed() async {
    try {
      String? storedUserId = await storage.read(key: 'user_id');
      final url = Uri.parse(
          '${AppConfig.baseUrl}/api/products/products/viewed/$storedUserId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] != null) {
          productsView = data['products'];
          notifyListeners();
          print("hoooouuuni");
          print(productsView);
        } else {
          print('Aucun produit trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<void> createRecentlyViewedProducts({
    required String productId,
  }) async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/api/products/createProductsViewed/');
    final headers = {
      'Content-Type': 'application/json',
    };
    print(productId);

    // Attendre la valeur du user_id
    String? storedUserId = await storage.read(key: 'user_id');
    print(storedUserId);
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "product_id": productId,
        "user_id": storedUserId, // Maintenant c'est une valeur et non un Future
      }),
    );

    // Vérifier la réponse
    if (response.statusCode == 200) {
      print("Produit ajouté aux vues récentes !");
    } else {
      print("Erreur : ${response.body}");
    }
  }

  Future<bool> checkOrderedorNot({
    required int first_id,
    required int second_id,
  }) async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/api/products/check_order_status/$first_id/$second_id/');
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print("yes");
      canRate = true;
      return true;
    } else {
      print("Erreur : ${response.body}");
      canRate = false;
      return false;
    }
  }

  Future<bool> createFavorite({
    required String productId,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/products/createFavourite/');
    final headers = {
      'Content-Type': 'application/json',
    };
    print(productId);

    String? storedUserId = await storage.read(key: 'user_id');
    print(storedUserId);
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "product_id": productId,
        "user_id": storedUserId, // Maintenant c'est une valeur et non un Future
      }),
    );
    if (response.statusCode == 201) {
      print("Produit ajouté aux favorites avec succees !");
      return true;
    } else if (response.statusCode == 200) {
      print("produit déja dans favoris");
      return true;
    } else {
      print("Erreur : ${response.body}");
      return false;
    }
  }

  Future<bool> createWish({
    required String productId,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/products/add_wish/');
    final headers = {
      'Content-Type': 'application/json',
    };
    print(productId);

    String? storedUserId = await storage.read(key: 'user_id');
    print(storedUserId);
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "product_id": productId,
        "user_id": storedUserId, // Maintenant c'est une valeur et non un Future
      }),
    );
    if (response.statusCode == 201) {
      print("Produit ajouté aux favorites avec succees !");
      return true;
    } else if (response.statusCode == 200) {
      print("produit déja dans favoris");
      return true;
    } else {
      print("Erreur : ${response.body}");
      return false;
    }
  }

  Future<bool> createComment({
    required String productId,
    required String content,
  }) async {
    String? storedUserId = await storage.read(key: 'user_id');
    final url = Uri.parse(
        '${AppConfig.baseUrl}/api/products/createComnt/$productId/$storedUserId/');
    final headers = {
      'Content-Type': 'application/json',
    };
    print(productId);

    print(storedUserId);
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "content": content, // Maintenant c'est une valeur et non un Future
      }),
    );
    if (response.statusCode == 201) {
      print("comnt ajouté");
      return true;
    } else {
      print("Erreur : ${response.body}");
      return false;
    }
  }

  Future<bool> getRatingByRatedUser({required int userId}) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/api/auth/getRatings/$userId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        Ratings = data["ratings"];
        avarageRate = data["average_rating"];
        countRate = data["count"];
        print("heeeeeeeyoidzjciopzej ${data["rating_percentages"]}");

        // Extraction des pourcentages de rating avec conversion en double
        ratingPercentage1 = (data["rating_percentages"]["1"] ?? 0).toDouble();
        ratingPercentage2 = (data["rating_percentages"]["2"] ?? 0).toDouble();
        ratingPercentage3 = (data["rating_percentages"]["3"] ?? 0).toDouble();
        ratingPercentage4 = (data["rating_percentages"]["4"] ?? 0).toDouble();
        ratingPercentage5 = (data["rating_percentages"]["5"] ?? 0).toDouble();

        print("Ratings: $Ratings");
        print("Average Rate: $avarageRate");
        print("Count Rate: $countRate");
        print("1 Star Percentage: $ratingPercentage1%");
        print("2 Stars Percentage: $ratingPercentage2%");
        print("3 Stars Percentage: $ratingPercentage3%");
        print("4 Stars Percentage: $ratingPercentage4%");
        print("5 Stars Percentage: $ratingPercentage5%");

        notifyListeners();
        return true;
      } else {
        print(
            'Erreur lors de la récupération des ratings: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
      return false;
    }
  }

  Future<bool> getRatingByRatedUserVisited({required int userId}) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/api/auth/getRatings/$userId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        RatingsVisited = data["ratings"];
        avarageRateVisited = data["average_rating"];
        countRateVisited = data["count"];
        print("heeeeeeeyoidzjciopzej ${data["rating_percentages"]}");

        // Extraction des pourcentages de rating avec conversion en double
        ratingPercentage1Visited =
            (data["rating_percentages"]["1"] ?? 0).toDouble();
        ratingPercentage2Visited =
            (data["rating_percentages"]["2"] ?? 0).toDouble();
        ratingPercentage3Visited =
            (data["rating_percentages"]["3"] ?? 0).toDouble();
        ratingPercentage4Visited =
            (data["rating_percentages"]["4"] ?? 0).toDouble();
        ratingPercentage5Visited =
            (data["rating_percentages"]["5"] ?? 0).toDouble();

        print("Ratings: $RatingsVisited");
        print("Average Rate: $avarageRateVisited");
        print("Count Rate: $countRateVisited");
        print("1 Star Percentage: $ratingPercentage1Visited%");
        print("2 Stars Percentage: $ratingPercentage2Visited%");
        print("3 Stars Percentage: $ratingPercentage3Visited%");
        print("4 Stars Percentage: $ratingPercentage4Visited%");
        print("5 Stars Percentage: $ratingPercentage5Visited%");

        notifyListeners();
        return true;
      } else {
        print(
            'Erreur lors de la récupération des ratings: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
      return false;
    }
  }

  Future<void> getFollowers(int userId) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/api/auth/get_followers/$userId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['followers'] != null) {
          nbfollowers = data["count"];
          followers = data['followers'];
          notifyListeners();
          print("hoooouuuni");
          print(followers);
        } else {
          print('Aucun produit trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<void> getFollowersVisited(int userId) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/api/auth/get_followers/$userId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['followers'] != null) {
          nbfollowervisited = data["count"];
          followersvisited = data['followers'];
          notifyListeners();
          print("hoooouuuni");
          print(followersvisited);
        } else {
          print('Aucun produit trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<void> getFavourite(int userId) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/api/products/getFavourite/$userId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['favorites'] != null) {
          favoriteProducts = data['favorites'];
          notifyListeners();
          print("Produits favoris récupérés : $favoriteProducts");
        } else {
          print('Aucun produit favori trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<void> getWish(int userId) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/api/products/get_wish/$userId/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['favorites'] != null) {
          wishProducts = data['favorites'];
          notifyListeners();
          print("Produits favoris récupérés : $wishProducts");
        } else {
          print('Aucun produit favori trouvé pour cet utilisateur.');
        }
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<bool> deleteProduct(String productId, int userId) async {
    try {
      final url = Uri.parse(
          '${AppConfig.baseUrl}/api/products/delete_product/$productId/$userId/');
      final headers = {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer votre_token', // Ajoutez l'en-tête d'autorisation si nécessaire
      };

      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 204) {
        // Si la suppression a réussi, retirez le produit de la liste locale
        products.removeWhere((product) => product['id'] == productId);
        notifyListeners(); // Notifiez les auditeurs de la mise à jour
        print('Produit favori supprimé avec succès.');
        return true;
      } else {
        print(
            'Erreur lors de la suppression du produit : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
      return false;
    }
  }

  Future<void> deleteFavorite(int favoriteId) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/api/products/deleteFav/$favoriteId/');
      final headers = {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer votre_token', // Ajoutez l'en-tête d'autorisation si nécessaire
      };

      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 204) {
        // Si la suppression a réussi, retirez le produit de la liste locale
        favoriteProducts
            .removeWhere((product) => product['id_fav'] == favoriteId);
        notifyListeners(); // Notifiez les auditeurs de la mise à jour
        print('Produit favori supprimé avec succès.');
      } else {
        print(
            'Erreur lors de la suppression du produit : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<void> deleteWish(int favoriteId) async {
    try {
      final url = Uri.parse(
          '${AppConfig.baseUrl}/api/products/deleteWish/$favoriteId/');
      final headers = {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer votre_token', // Ajoutez l'en-tête d'autorisation si nécessaire
      };

      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 204) {
        // Si la suppression a réussi, retirez le produit de la liste locale
        wishProducts.removeWhere((product) => product['id_wish'] == favoriteId);
        notifyListeners(); // Notifiez les auditeurs de la mise à jour
        print('Produit favori supprimé avec succès.');
      } else {
        print(
            'Erreur lors de la suppression du produit : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur rencontrée : $e');
    }
  }

  Future<bool> createOrder(
      int buyerId, List<dynamic> productIds, String status, int price) async {
    final response = await http.post(
      Uri.parse("${AppConfig.baseUrl}/api/products/create_order/"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "buyer_id": buyerId,
        "product_ids": productIds, // Liste des IDs de produits
        "status": status,
        "price": price // Statut de la commande, par défaut 'livraison'
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final totalPrice = data["total_price"];
      notifyListeners();
      print("Commandes créées avec succès. Prix total: $totalPrice");
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProductSelled(String productId, bool selled) async {
    final String url =
        '${AppConfig.baseUrl}/api/products/update_product_selled/$productId/'; // Remplace par l'URL de ton API

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'selled': selled}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Champ "selled" mis à jour avec succès: ${data['selled']}');
      return true;
    } else {
      final errorData = jsonDecode(response.body);
      return false;
    }
  }
}
