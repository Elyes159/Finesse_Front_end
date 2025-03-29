import 'dart:convert';
import 'dart:math';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Stories extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  bool isStoryCreated = false;
  bool hasStory = false;
  Users? _currentUser;
  late List<dynamic> followersIds = [];
  List<Map<String, dynamic>> _stories = [];
  List<Map<String, dynamic>> _myStories = [];
  List<Map<String, dynamic>> get stories => _stories;
  List<Map<String, dynamic>> get myStories => _myStories;

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

  Future<void> fetchFollowersAndStories({required int userId}) async {
    try {
      // Étape 1 : Récupérer les IDs des followers
      final followersUrl =
          Uri.parse("${AppConfig.baseUrl}/api/stories/followers_ids/$userId/");
      final followersResponse = await http
          .get(followersUrl, headers: {'Content-Type': 'application/json'});

      if (followersResponse.statusCode == 200) {
        List<dynamic> followersIds =
            jsonDecode(followersResponse.body)["followers_ids"];
        print("Followers IDs: $followersIds");

        if (followersIds.isNotEmpty) {
          // Étape 2 : Récupérer les stories des followers
          String userIdsString = followersIds.join(',');
          final storiesUrl = Uri.parse(
              "${AppConfig.baseUrl}/api/stories/followed_stories/$userIdsString/");
          final storiesResponse = await http.get(storiesUrl);

          if (storiesResponse.statusCode == 200) {
            Map<String, dynamic> data = jsonDecode(storiesResponse.body);
            _stories = List<Map<String, dynamic>>.from(data['stories']);
            print("Stories: $_stories");
            notifyListeners();
          } else {
            print(
                "Erreur stories: ${storiesResponse.statusCode} - ${storiesResponse.body}");
          }
        } else {
          print("Aucun follower trouvé.");
          _stories = [];
          notifyListeners();
        }
      } else {
        print(
            "Erreur followers: ${followersResponse.statusCode} - ${followersResponse.body}");
      }
    } catch (e) {
      print("Erreur lors de la requête: $e");
    }
  }

  // Fonction pour récupérer les stories de l'utilisateur actuel
  Future<void> fetchUserStories({required int userId}) async {
    try {
      final url = Uri.parse(
          "${AppConfig.baseUrl}/api/stories/get_user_stories/$userId/");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        _myStories = List<Map<String, dynamic>>.from(data['stories']);
        print("Stories de l'utilisateur actuel: $_stories");
        notifyListeners();
      } else {
        print(
            "Erreur lors de la récupération des stories de l'utilisateur : ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Erreur lors de la requête: $e");
    }
  }
}
