import 'dart:convert';
import 'dart:math';

import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';




class AuthService with ChangeNotifier{
  String _accessToken = '';
  bool _isAuthenticated = false;
  Users? _currentUser;
  int _userId = 0;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  String _googleAvatar = "";
  String _fullnameGoogle = "";
  final storage = FlutterSecureStorage();




  bool get isAuthenticated => _isAuthenticated;
  Users? get currentUser => _currentUser;
  int get userId => _userId;
  String get googleAvatar => _googleAvatar;
  String get fullnameGoogle => _fullnameGoogle;

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
    required String firstName,
    required String lastName,
  })async{
    final url = Uri.parse("${AppConfig.TestClientUrl}/api/auth/signup/");
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
}) async {
  final url = Uri.parse("${AppConfig.TestClientUrl}/api/auth/signin/");
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    _accessToken = data['access_token']; // Récupération du token
    _isAuthenticated = true;

    // Enregistrement du token dans le stockage
    await storage.write(key: 'access_token', value: _accessToken);

    // Assurez-vous d'extraire les informations utilisateur et de les assigner à _currentUser
    _currentUser = Users.fromJson(data);
      await storage.write(key: 'user_id', value: _currentUser!.id.toString());
      await storage.write(key: 'user_email', value: _currentUser!.email);
      await storage.write(key: 'user_phone_number', value: _currentUser!.phoneNumber);
      await storage.write(key: 'user_username', value: _currentUser!.username);
      await storage.write(key: 'user_avatar', value: _currentUser!.avatar ?? ''); // Si avatar est null, on peut le mettre comme une chaîne vide
      await storage.write(key: 'user_address', value: _currentUser!.address);
      await storage.write(key: 'user_is_email_verified', value: _currentUser!.isEmailVerified.toString());
      await storage.write(key: 'user_verification_code', value: _currentUser!.verificationCode);
      await storage.write(key: 'user_description', value: _currentUser!.description);
      await storage.write(key: 'user_full_name', value: _currentUser!.fullName);
      await storage.write(key: 'parametre', value: "normal");
      await storage.write(key: 'hasStory',value:_currentUser!.hasStory.toString());
    notifyListeners();
  } else {
    throw Exception('Erreur lors de la connexion : ${response.statusCode}');
  }
}

Future<void> loadUserData() async {
  String? storedToken = await storage.read(key: 'access_token');
  String? storedUsername = await storage.read(key: 'user_username');
  String? storedUserId = await storage.read(key: 'user_id');
  String? storedUserEmail = await storage.read(key: 'user_email');
  String? storedUserPhoneNumber = await storage.read(key: 'user_phone_number');
  String? storedUserAvatar = await storage.read(key: 'user_avatar');
  String? storedUserFullName = await storage.read(key: 'user_full_name');
  String? storedUserAddress = await storage.read(key: 'user_address');
  String? storedUserIsEmailVerified = await storage.read(key: 'user_is_email_verified');
  String? storedUserVerificationCode = await storage.read(key: 'user_verification_code');
  String? storedUserDescription = await storage.read(key: 'user_description');
  String? storedHasStory = await storage.read(key: 'hasStory');

  if (storedToken != null && storedUserId != null) {
    // Récupérer et assigner les données utilisateur
    _accessToken = storedToken;

   _currentUser = Users(
      id: int.parse(storedUserId),  // Vérifiez les valeurs par défaut si null
      username: storedUsername!,
      email: storedUserEmail!,
      phoneNumber: storedUserPhoneNumber!,
      avatar: storedUserAvatar,
      fullName: storedUserFullName!,
      address: storedUserAddress!,
      isEmailVerified: storedUserIsEmailVerified == 'true', // Conversion en booléen
      verificationCode: storedUserVerificationCode!,
      description: storedUserDescription!,
      hasStory: storedHasStory == "true",
    );

    _isAuthenticated = true;
    notifyListeners();
  } else {
    _isAuthenticated = false;
  }
}


 void signOut() async {
  // Supprimer les données stockées dans FlutterSecureStorage
  await storage.delete(key: 'access_token');
  await storage.delete(key: 'user_id');
  await storage.delete(key: 'user_email');
  await storage.delete(key: 'user_phone_number');
  await storage.delete(key: 'user_first_name');
  await storage.delete(key: 'user_last_name');
  await storage.delete(key: 'user_avatar');
  await storage.delete(key: 'user_full_name');
  await storage.delete(key: 'user_address');
  await storage.delete(key: 'user_is_email_verified');
  await storage.delete(key: 'user_verification_code');
  await storage.delete(key: 'user_description');

  // Réinitialiser les variables locales
  _accessToken = '';
  _isAuthenticated = false;
  _currentUser = null;

  // Notifier les listeners que l'utilisateur s'est déconnecté
  notifyListeners();
}


  Future<void> confirmEmailVerification({
    required int userId,
    required String? verificationCode,
  })async{
    final url = Uri.parse("${AppConfig.TestClientUrl}/api/auth/verify-code/");
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
  final url = Uri.parse("${AppConfig.TestClientUrl}/api/auth/$userId/register_profile/");
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
Future<void> registerProfileGoogle({
  required String full_name,
  required String phone_number,
  required String address,
  required String description,
  required int userId,
}) async {
  final url = Uri.parse("${AppConfig.TestClientUrl}/api/auth/$userId/register_profile_google/");

  // Création du corps de la requête JSON
  final Map<String, dynamic> body = {
    'full_name': full_name,
    'phone_number': phone_number,
    'address': address,
    'description': description,
  };

  try {
    // Envoi de la requête POST avec le corps JSON
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', 
      },
      body: jsonEncode(body), 
    );

    if (response.statusCode == 200) {
      print("Profil enregistré avec succès");
    } else {
      print("Erreur lors de l'enregistrement : ${response.body}");
      throw Exception("Erreur ${response.statusCode}: ${response.body}");
    }
  } catch (e) {
    print("Exception : ${e.toString()}");
    throw Exception("Erreur lors de l'envoi des données : ${e.toString()}");
  }
}

Future<void> createUsername({
  required String username,
  required bool isPolicy,
  required bool isMail,
  required int userId,
}) async {
  final url = Uri.parse("${AppConfig.TestClientUrl}/api/auth/$userId/createUsername/");
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
Future<void> createUsernameGoogle({
  required String username,
  required bool isPolicy,
  required bool isMail,
  required int userId,
}) async {
  final url = Uri.parse("${AppConfig.TestClientUrl}/api/auth/$userId/createUsernamegoogle/");
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
Future<void> signUpGoogle() async {
  print("i'm used");
  try {
    GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account != null) {
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final String? idToken = googleAuth.idToken;
      print(idToken);
      final String? accessToken = googleAuth.accessToken;

      if (idToken != null) {
        // Récupérer les informations supplémentaires de l'utilisateur
        final String userEmail = account.email;
        final String userFirstName = account.displayName?.split(' ').first ?? '';
        final String userLastName = account.displayName?.split(' ').last ?? '';
        final String userAvatar = account.photoUrl ?? '';

        // Construire le payload JSON
        final Map<String, dynamic> bodyData = {
          'id_token': idToken,
          'email': userEmail,
          'first_name': userFirstName,
          'last_name': userLastName,
          'avatar': userAvatar,
        };

        final response = await http.post(
          Uri.parse('${AppConfig.TestClientUrl}/api/auth/googleSign/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(bodyData), // Sérialiser les données en JSON
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body); // Décoder la réponse JSON
          _userId = data["user"]["id"];
          _fullnameGoogle = "${data["user"]["last_name"]} ${data["user"]["first_name"]}";
          _googleAvatar = "${data["user"]["avatar"]}";
           // Utiliser les données reçues
          notifyListeners();
        } else {
          print("Erreur d'authentification : ${response.statusCode}");
          print("Message : ${response.body}");
        }
      }
    }
  } catch (error) {
    print("Erreur lors de la connexion avec Google: $error");
  }
}
Future<bool> googleLogin() async {
  try {
    GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account != null) {
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      final url = Uri.parse("${AppConfig.TestClientUrl}/api/auth/googlelogin/");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_token': idToken,  // L'ID Token Google que vous avez récupéré via le SDK Google
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Vérification si l'email existe déjà dans la base de données
        if (response.body.contains("Email does not exist in the database")) {
          // Retourner false si l'email n'existe pas
          throw Exception('Email does not exist in the database');
        }

        // Extraire le token d'accès et autres informations utilisateur
        _accessToken = data['access_token'];
        _isAuthenticated = true;

        // Créer une instance de UsersGoogle à partir des données retournées
        _currentUser = Users.fromJson(data);
      await storage.write(key: 'access_token', value: _accessToken);
      await storage.write(key: 'user_id', value: _currentUser!.id.toString());
      await storage.write(key: 'user_email', value: _currentUser!.email);
      await storage.write(key: 'user_phone_number', value: _currentUser!.phoneNumber);
      await storage.write(key: 'user_username', value: _currentUser!.username);
      await storage.write(key: 'user_avatar', value: _currentUser!.avatar ?? ''); // Si avatar est null, on peut le mettre comme une chaîne vide
      await storage.write(key: 'user_address', value: _currentUser!.address);
      await storage.write(key: 'user_is_email_verified', value: _currentUser!.isEmailVerified.toString());
      await storage.write(key: 'user_verification_code', value: _currentUser!.verificationCode);
      await storage.write(key: 'user_description', value: _currentUser!.description);
      await storage.write(key: 'user_full_name', value: _currentUser!.fullName);
      await storage.write(key: 'parametre', value: "google");
        notifyListeners();  // Mettre à jour les listeners pour la gestion de l'état
        return true;  // Retourner true si la connexion est réussie
      } else {
        // Si le code de statut n'est pas 200, on capture l'erreur ici
        print('Erreur lors de la connexion avec Google: ${response.body}');
        return false; // Retourner false en cas d'échec de la connexion
      }
    } else {
      // Gestion de l'annulation de la connexion Google
      print('L\'utilisateur a annulé la connexion Google.');
      return false;
    }
  } catch (e) {
    // Attraper l'exception générée par l'email existant ou d'autres erreurs
    if (e is Exception && e.toString() == 'Email does not exist in the database') {
      print('L\'email n\'existe pas dans la base de données. Vous pouvez vous inscrire.');
      return false; // Retourner false si l'email n'existe pas
    } else {
      print('Erreur lors de la connexion avec Google: $e');
      return false; // Retourner false en cas d'erreur
    }
  }
}



  Future<void> loadUserGoogleData() async {
    String? storedToken = await storage.read(key: 'access_token');
    String? storedUsername = await storage.read(key: 'user_username');
    String? storedUserId = await storage.read(key: 'user_id');
    String? storedUserEmail = await storage.read(key: 'user_email');
    String? storedUserPhoneNumber = await storage.read(key: 'user_phone_number');
    String? storedUserAvatar = await storage.read(key: 'user_avatar');
    String? storedUserFullName = await storage.read(key: 'user_full_name');
    String? storedUserAddress = await storage.read(key: 'user_address');
    String? storedUserDescription = await storage.read(key: 'user_description');
  String? storedHasStory = await storage.read(key: 'hasStory');

    if (storedToken != null && storedUserId != null) {
      _accessToken = storedToken;
      _currentUser = Users(
        id: int.parse(storedUserId),
        email: storedUserEmail!,
        username: storedUsername!,
        fullName: storedUserFullName!,
        avatar: storedUserAvatar!,
         phoneNumber: storedUserPhoneNumber!,
          address: storedUserAddress!,
           description: storedUserDescription!,
           hasStory: storedHasStory == "true",

      );
      _isAuthenticated = true;
      notifyListeners();
    } else {
      _isAuthenticated = false;
    }
  }
   void signOutGoogle() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'user_id');
    await storage.delete(key: 'user_email');
    await storage.delete(key: 'user_username');
    await storage.delete(key: 'user_first_name');
    await storage.delete(key: 'user_last_name');
    await storage.delete(key: 'user_full_name');
    await storage.delete(key: 'user_avatar');

    _accessToken = '';
    _isAuthenticated = false;
    _currentUser = null;

    notifyListeners();
  }

}