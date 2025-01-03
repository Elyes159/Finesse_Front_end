import 'dart:math';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Stories extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  bool isStoryCreated = false;
  bool hasStory = false;
  Users? _currentUser;
  Users? get currentUser => _currentUser;

  Future<void> createStory({
    required String? userId,
    required XFile? storyImage,
  }) async {
    if (storyImage == null) {
      throw Exception("Aucune image sélectionnée pour la story.");
    }

    final url =
        Uri.parse("${AppConfig.baseUrl}/api/stories/createStory/$userId/");
    var request = http.MultipartRequest('POST', url);

    var file =
        await http.MultipartFile.fromPath('story_image', storyImage.path);
    request.files.add(file);

    // Envoyer la requête
    var response = await request.send();

    if (response.statusCode == 201) {
      print("Story créée avec succès");
      isStoryCreated = true;
      await storage.write(key: 'hasStory', value: "true");

      hasStory = true;
      notifyListeners();
    } else {
      throw Exception(
          "Erreur lors de la création de la story. Code: ${response.statusCode}");
    }
  }

  Future<void> loadUserStoriesData() async {
    try {
      String? hasStoryS = await storage.read(key: 'hasStory');

      hasStory = hasStoryS == "true";
      notifyListeners();
    } catch (e) {
      print("Erreur lors du chargement des données utilisateur : $e");
    }
  }
}
