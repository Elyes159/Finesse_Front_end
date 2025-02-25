import 'dart:io';

import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? parametre = "facebook";
  String? errorMessage;
  File? _selectedImage; // Variable pour stocker l'image sélectionnée

  // Ajout du pickeur d'image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path); // Mettre à jour l'image sélectionnée
      });
    }
  }

  Future<void> _loadParameter() async {
    parametre = await const FlutterSecureStorage().read(key: 'parametre');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadParameter();
    print(parametre);
    print("heeeeeeeeeeeey");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser!;

        TextEditingController _fullnameController =
            TextEditingController(text: user.fullName);
        TextEditingController _usernameController =
            TextEditingController(text: user.username);
        TextEditingController _emailController =
            TextEditingController(text: user.email);
        TextEditingController _phoneController =
            TextEditingController(text: user.phoneNumber);
        TextEditingController _addressController =
            TextEditingController(text: user.address);

        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Text(
                  'Account',
                  style: TextStyle(
                    color: Color(0xFF111928),
                    fontSize: 16,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              // Container for CircleAvatar with edit icon
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: parametre == null
                    ? CircularProgressIndicator()
                    : Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          InkWell(
                            onTap:  parametre == "normal" ? () {
                              _pickImage(); // Appeler la fonction pour choisir une image
                            } : null,
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!) // Utiliser l'image sélectionnée
                                  : (user.avatar != "" && user.avatar != null)
                                      ? NetworkImage(parametre == "normal"
                                          ? "${AppConfig.baseUrl}${user.avatar}"
                                          : user.avatar!)
                                      : AssetImage('assets/images/user.png')
                                          as ImageProvider,
                              backgroundColor: Colors.transparent,
                              child: user.avatar == null
                                  ? Icon(Icons.person,
                                      size: 50, color: Colors.white)
                                  : null,
                            ),
                          ),
                          if (parametre == "normal")
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/Icons/gallery-edit.svg",
                                width: 15,
                                height: 15,
                              ),
                            ),
                        ],
                      ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              // ListView for other content
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    CustomTextFormField(
                        controller: _fullnameController,
                        label: "Full Name",
                        isPassword: false),
                    SizedBox(
                      height: 16,
                    ),
                    CustomTextFormField(
                        controller: _usernameController,
                        label: "Username",
                        isPassword: false),
                    SizedBox(
                      height: 16,
                    ),
                    CustomTextFormField(
                        controller: _emailController,
                        label: "E-mail",
                        isPassword: false),
                    SizedBox(
                      height: 16,
                    ),
                    CustomTextFormField(
                        controller: _phoneController,
                        label: "Phone",
                        isPassword: false),
                    SizedBox(
                      height: 16,
                    ),
                    CustomTextFormField(
                        controller: _addressController,
                        label: "Address",
                        isPassword: false),
                    SizedBox(
                      height: 40,
                    ),
                    CustomButton(
                      buttonColor: Color(0xFFC668AA),
                      label: "Save changes",
                      onTap: () async {
                        // Appel de la fonction updateProfile
                        int statusCode = await authService.updateProfile(
                          user.id,
                          _fullnameController.text,
                          _usernameController.text,
                          _phoneController.text,
                          _addressController.text,
                          _selectedImage, // Passer le fichier d'image sélectionné
                        );

                        if (statusCode == 200) {
                          Provider.of<AuthService>(context,listen:false).loadUserData();
                          setState(() {
                            errorMessage = null; // Réinitialiser le message d'erreur
                          });
                        } else {
                          setState(() {
                            if (statusCode == 444) {
                              errorMessage = 'Username invalid'; // Message d'erreur spécifique
                            } else {
                              errorMessage = 'Failed to update profile'; // Message d'erreur générique
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

