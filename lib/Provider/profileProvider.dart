import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finesse_frontend/ApiServices/backend_url.dart';
import '../Models/user.dart';

class Profileprovider with ChangeNotifier {
  Users? _visitedProfile;
  Users? get visitedProfile => _visitedProfile;

  Future<void> fetchProfile(int userId) async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/api/auth/getUserProfileVisit/$userId/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

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
          description: data["user_profile"]['description'] ?? "",
          hasStory: data["user_profile"]['hasStory'] ?? false,
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
}
