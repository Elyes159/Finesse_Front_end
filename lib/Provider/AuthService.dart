import 'dart:convert';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AuthService with ChangeNotifier{
  String _accessToken = '';
  bool _isAuthenticated = false;
  User? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;

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
      print('utilisateur creer');
    }else{
      throw Exception('erreur lors de la création');
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

      _currentUser = User.fromJson(data['user']);
      notifyListeners();
    }else{
      throw Exception('Erreur lors de la connexion');
    }
  }

  void signOut(){
    _accessToken = '';
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}