import 'dart:convert';
import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Models/virement.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        final virementsData = data['virements'] as List?;

        // Si la liste 'virements' est vide ou nulle, on ne fait rien et on considère qu'il n'y a pas d'erreur
        if (virementsData != null && virementsData.isNotEmpty) {
          _virements = virementsData.map((virement) {
            return Virement.fromJson(virement);
          }).toList();
        } else {
          _virements = []; // Aucune donnée à afficher
        }
      } else {
        // Si la réponse n'est pas 200, on traite l'erreur sans utiliser rethrow
        _virements = [];
        print('Erreur lors de la récupération des virements: ${response.statusCode}');
      }
    } catch (error) {
      // Capture l'erreur sans rethrow, on peut loguer ou traiter l'erreur
      _virements = [];
      print('Erreur: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
