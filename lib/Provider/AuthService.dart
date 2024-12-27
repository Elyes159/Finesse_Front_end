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

  Future<void>regiterProfile({
    required String full_name,
    required String phone_number,
    required String address,
    required String description,
    XFile? image,
    required int userId

  }) async{
      final url = Uri.parse("${AppConfig.baseUrl}/api/auth/$userId/register_profile/");
      final response = await http.post(
        url,
        headers: {"Content-Type":"application/json"},
        body: json.encode({
          "full_name":full_name,
          "phone_number" :phone_number,
          "address":address,
          "description":description,
          "avatar":image,
        }),
      );
      if (response.statusCode==200){
        print("user cree avec succees");
      }else {
        throw Exception('${json.decode(response.body)}');
      }

  }
}