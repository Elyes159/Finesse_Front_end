import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Models/notif.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // Fonction pour récupérer les notifications de l'API
  Future<void> fetchNotifications(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/auth/get_user_notifications/$userId/'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Vérifiez si la clé "notifications" est présente dans la réponse
        if (data.containsKey('notifications')) {
          final List<dynamic> notificationsList = data['notifications'];
          _notifications = notificationsList
              .map((notificationJson) =>
                  NotificationModel.fromJson(notificationJson))
              .toList();
        } else {
          // Gérer l'erreur ici si la clé "notifications" est manquante
          throw Exception('La clé "notifications" est manquante');
        }
      } else {
        // Gérer les autres erreurs HTTP
        throw Exception('Erreur lors de la récupération des notifications');
      }
    } catch (e) {
      print("Erreur: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
