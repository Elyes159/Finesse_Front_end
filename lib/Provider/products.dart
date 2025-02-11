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
  late List productsByUser = [];

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
}
