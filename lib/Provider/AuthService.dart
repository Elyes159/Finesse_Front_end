import 'dart:convert';
import 'dart:math';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class AuthService with ChangeNotifier{
  String _accessToken = '';
  bool _isAuthenticated = false;
  Users? _currentUser;
  int _userId = 0;

  bool get isAuthenticated => _isAuthenticated;
  Users? get currentUser => _currentUser;
  int get userId => _userId;

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
    required String firstName,
    required String lastName,
  })async{
    final url = Uri.parse("${AppConfig.baseUrl}/api/auth/signup/");
    final response = await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body: json.encode({
        'username' : username,
        'email' : email,
        'password' : password,
        'phone_number' : phoneNumber,
        'first_name' : firstName,
        'last_name' : lastName,
      }),
    );
    if(response.statusCode == 201){
      print("heeeeeeeeeeey");
      print(json.decode(response.body)["id"]);

      final data = json.decode(response.body);
      print(data);
      _userId = data["id"];
      notifyListeners();
      print('utilisateur creer');
    }else{
      throw Exception('erreur lors de la création ${response.body}');
    }
  }
  Future<void> signIn({
    required String username,
    required String password,
  }) async{
    final url = Uri.parse("${AppConfig.baseUrl}/api/auth/signin/");
    final response = await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body: json.encode({
        'username':username,
        'password' : password,
      })
    );
    if (response.statusCode == 200){
      final data = json.decode(response.body);

      _accessToken = data['access_token'];
      _isAuthenticated = true;

      _currentUser = Users.fromJson(data['user']);
      notifyListeners();
    }else{
      throw Exception('Erreur lors de la connexion ${e.toString()}');
    }
  }

  void signOut(){
    _accessToken = '';
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

  Future<void> confirmEmailVerification({
    required int userId,
    required String? verificationCode,
  })async{
    final url = Uri.parse("${AppConfig.baseUrl}/api/auth/verify-code/");
    final response = await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body : json.encode({
        'user_id':userId,
        'verification_code':verificationCode,
      }),
    );
    if (response.statusCode == 200){
      print("Email succesfully verfied");
    }else{
      throw Exception('${json.decode(response.body)}');
    }
  }

  Future<void> registerProfile({
  required String full_name,
  required String phone_number,
  required String address,
  required String description,
  XFile? image,
  required int userId
}) async {
  final url = Uri.parse("${AppConfig.baseUrl}/api/auth/$userId/register_profile/");

  var request = http.MultipartRequest('POST', url)
    ..fields['full_name'] = full_name
    ..fields['phone_number'] = phone_number
    ..fields['address'] = address
    ..fields['description'] = description;

  // Si l'image est non nulle, ajoutez-la à la requête
  if (image != null) {
    // Assurez-vous de récupérer le chemin de l'image
    var file = await http.MultipartFile.fromPath('avatar', image.path);
    request.files.add(file);
  }

  // Envoyer la requête
  var response = await request.send();

  if (response.statusCode == 200) {
    print("User créé avec succès");
  } else {
    throw Exception("error ${e.toString()}");
  }
}

Future<void> createUsername({
  required String username,
  required bool isPolicy,
  required bool isMail,
  required int userId,
}) async {
  final url = Uri.parse("${AppConfig.baseUrl}/api/auth/$userId/createUsername/");
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      "username": username,
      "policy": isPolicy,
      "mail": isMail,
    }),
  );

  if (response.statusCode == 200) {
    print("User créé avec succès");
  } else {
    // Lever une exception avec le message d'erreur renvoyé par le serveur
    final errorMessage = json.decode(response.body)['message'] ?? 'Une erreur est survenue';
    throw Exception(errorMessage);
  }
}


}