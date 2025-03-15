import 'dart:convert';
import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Models/virement.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'virement.dart';

class VirementProvider with ChangeNotifier {
  List<Virement> _virements = [];
  bool _isLoading = false;

  List<Virement> get virements => _virements;
  bool get isLoading => _isLoading;

  // URL de votre API 
  final String baseUrl = AppConfig.baseUrl; // Remplacez par l'URL de votre API

  // Fonction pour obtenir les virements d'un utilisateur par user_id
  Future<void> fetchVirements(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/get_virements_by_user/$userId/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final virementsData = data['virements'] as List;

        _virements = virementsData.map((virement) {
          return Virement.fromJson(virement);
        }).toList();
      } else {
        throw Exception('Erreur lors de la récupération des virements');
      }
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
