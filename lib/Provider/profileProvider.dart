import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finesse_frontend/ApiServices/backend_url.dart';
import '../Models/user.dart';

class Profileprovider with ChangeNotifier {
  Users? _visitedProfile;
  Users? get visitedProfile => _visitedProfile;

 Future<void> fetchProfile(int userId) async {
  final url = Uri.parse('${AppConfig.baseUrl}/api/auth/getUserProfileVisit/$userId/');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Récupérer la liste des artistes dans la réponse
     

      _visitedProfile = Users(
        id: userId,
        username: data["user_profile"]['username'] ?? "",
        email: data["user_profile"]['email'] ?? "",
        phoneNumber: data["user_profile"]['phone_number'] ?? "",
        avatar: data["user_profile"]['avatar'] ?? "",
        fullName: data["user_profile"]['full_name'] ?? "",
        address: data["user_profile"]['address'] ?? "",
        isEmailVerified: data["user_profile"]['is_email_verified'] ?? false,
        verificationCode: data["user_profile"]['verification_code'] ?? "",

        hasStory: data["user_profile"]['hasStory'] ?? false,
        activite: data["user_profile"]["activite"] ?? "Autres", description: data["user_profile"]["description"],  // Ajouter la liste des artistes
      );
      notifyListeners();
    } else {
      throw Exception("Erreur lors du chargement du profil");
    }
  } catch (error) {
    print("Erreur: $error");
  }
}


  // Fonction pour ajouter un review
  Future<bool> addReview(
      int userId, int ratedUserId, int ratingValue, String content) async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/api/auth/addReview/'); // API endpoint pour ajouter un review

    try {
      final body = jsonEncode({
    'user_id': userId,
    'rated_user_id': ratedUserId,
    'rating_value': ratingValue,
    'content': content,
  });
      final response = await http.post(
        url,
        headers: {
          'Content-Type':
              'application/json', // Assurez-vous de spécifier le type de contenu JSON
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          print("Review ajouté avec succès");
        } else {
          print("Erreur: ${data['message']}");
        }
        return true;
      } else {
        print("Erreur serveur: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      print("Erreur lors de l'ajout du review: $error");
      return false;
    }
  }
  Future<bool> followUser(int followerId, int followedId) async {
  final url = Uri.parse('${AppConfig.baseUrl}/api/auth/follow_user/$followerId/$followedId/');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      print("Utilisateur suivi avec succès.");
      notifyListeners();
      return true;
    } else if (response.statusCode == 200) {
      print("Vous suivez déjà cet utilisateur.");
      return true;
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print("Erreur: ${data['error'] ?? 'Une erreur est survenue'}");
      return false;
    }
  } catch (error) {
    print("Erreur lors du follow: $error");
    return false;
  }
}
 List<dynamic> artistsList = [];
Future<void> getArtistsIds(int userId) async {
  // URL de l'API Django
  final String url = '${AppConfig.baseUrl}/api/auth/get_artists_ids/$userId/'; // Remplacez par l'URL de votre API

  try {
    // Effectuer la requête GET avec l'ID utilisateur
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(' JHFEZIJFPOEJFPOEAJFPOEAJ Message: ${responseData['message']}');
      print('Liste des artistes: ${responseData['list_id']}');
      
      artistsList = responseData['list_id'];
      notifyListeners();
    } else {
      // Si la réponse a échoué
      final Map<String, dynamic> errorData = json.decode(response.body);
      print(' zefjezpPDJCPEZJPEZE Erreur: ${errorData['message']}');
    }
  } catch (e) {
    // En cas d'erreur de connexion ou d'exécution
    print('Erreur lors de la récupération des artistes: $e');
  }
}

}
