import 'dart:io';

import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Screens/AuthScreens/letzGo.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/DescTextField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/LoginTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';


class CompleteInfo extends StatefulWidget {
  const CompleteInfo({super.key});

  @override
  State<CompleteInfo> createState() => _CompleteInfoState();
}

class _CompleteInfoState extends State<CompleteInfo> {
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

   Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image; 
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icons/ArrowLeft.svg', // Chemin de l'icône SVG
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          // Titre principal
          const Text(
            'Complete info',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF111928),
              fontSize: 32,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          // Sous-titre
          const Text(
            'Set up your profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF111928),
              fontSize: 16,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
              child: GestureDetector(
                onTap: () {
                  // Action lors du clic
                  _pickImage();
                },
                child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        shape: BoxShape.circle,
                      ),
                      child: _imageFile == null
                          ? const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 40,
                            )
                          : ClipOval(
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.grey.withOpacity(0.5),
                                  BlendMode.saturation,
                                ),
                                child: Image.file(
                                  File(_imageFile!.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
              ),
            ),
            const SizedBox(height: 16),
            // Champ de texte pour le nom complet
            CustomTextFormField(
              controller: _fullnameController,
              label: "Your full name",
              isPassword: false,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left:0,right: 0),
              child: Row(
                children: [
                  // Champ pour le code du pays
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: 120,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFF5C7CA4)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: IntlPhoneField(
                        showDropdownIcon: false,
                        style: TextStyle(fontFamily: "Raleway"), // Style du champ principal
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                            color: Color(0xFF3E536E),
                            fontSize: 16,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: 0.5,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                        initialCountryCode: 'TN', // Code par défaut
                        pickerDialogStyle: PickerDialogStyle(
                          countryNameStyle: const TextStyle(
                            fontFamily: 'Raleway', // Appliquer la police Raleway
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black, // Couleur du texte des pays
                          ),
                          countryCodeStyle: const TextStyle(
                            fontFamily: 'Raleway', // Appliquer la police Raleway pour les codes
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey, // Couleur des codes
                          ),
                          searchFieldInputDecoration: InputDecoration(
                            hintText: 'Search country',
                            hintStyle: const TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        dropdownTextStyle: TextStyle(fontFamily: "Raleway"),
                        flagsButtonPadding: const EdgeInsets.only(right: 8.0),
                        onCountryChanged: (country) {
                          print('Code pays sélectionné : ${country.dialCode}');
                        },
                        onChanged: (_) {},
                      ),
                    ),
                  ),
            
                  const SizedBox(width: 10),
                  // Champ principal pour le numéro de téléphone
                  Expanded(child: CustomTextFormField(controller: _phoneController, label: "Phone number", isPassword: false,keyboardType: TextInputType.numberWithOptions(),))
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomTextFormField(controller: _addressController, label: "Address", isPassword: false),
            const SizedBox(height: 16,),
            DescTextField(controller: _descriptionController, label: "Description", isPassword: false),
            const SizedBox(height: 16,),
            CustomButton(label: "Create account", onTap: (){
                Provider.of<AuthService>(context,listen: false).regiterProfile(full_name: _fullnameController.text, phone_number: _phoneController.text, address: _addressController.text, description: _descriptionController.text, userId: Provider.of<AuthService>(context,listen: false).userId);

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LetzGo()));
            }
            )
            ],),
          ),
          
        ],
      ),
    );
  }
}
