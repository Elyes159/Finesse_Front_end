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
  late List products = [];
  late List productsView = [];
  late List Ratings = [];
  late List productsByUser = [];
  double? avarageRate;
  int? countRate;
  late double ratingPercentage1 = 0;
  late double ratingPercentage2 = 0;
  late double ratingPercentage3 = 0;
  late double ratingPercentage4 = 0;
  late double ratingPercentage5 = 50;


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
      List<File?> images) async {
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

  Future<void> getProductsByUser() async {
    try {
      String? storedUserId = await storage.read(key: 'user_id');
      final url = Uri.parse(
          '${AppConfig.baseUrl}/api/products/getProductsByUser/${storedUserId}/');
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] != null) {
          productsByUser = data['products'];
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

    Future<void> getProductsViewed() async {
    try {
      String? storedUserId = await storage.read(key: 'user_id');
      final url = Uri.parse('${AppConfig.baseUrl}/api/products/products/viewed/$storedUserId/');
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
  final url = Uri.parse('${AppConfig.baseUrl}/api/products/createProductsViewed/');
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
  } else if(response.statusCode==200){
    print("produit déja dans favoris");
    return true;
  }
   else {
    print("Erreur : ${response.body}");
    return false;
  }
}
Future<bool> createComment({
  required String productId,
  required String content,
  
}) async {
  String? storedUserId = await storage.read(key: 'user_id');
  final url = Uri.parse('${AppConfig.baseUrl}/api/products/createComnt/$productId/$storedUserId/');
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
  } 
   else {
    print("Erreur : ${response.body}");
    return false;
  }
}
Future<bool> getRatingByRatedUser({required int userId}) async {
  try {
    final url = Uri.parse('${AppConfig.baseUrl}/api/auth/getRatings/$userId/');
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
      print('Erreur lors de la récupération des ratings: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Erreur rencontrée : $e');
    return false;
  }
}


}
