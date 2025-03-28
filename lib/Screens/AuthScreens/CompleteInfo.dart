import 'dart:convert';
import 'dart:io';
import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/products.dart';
import 'package:finesse_frontend/Screens/AuthScreens/letzGo.dart';
import 'package:finesse_frontend/Screens/AuthScreens/memebers.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomOptionsFields/optionsField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/DescTextField.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/artistsfirld.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/categoryAbsorb.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CompleteInfo extends StatefulWidget {
  final String parameter;

  const CompleteInfo({super.key, required this.parameter});

  @override
  State<CompleteInfo> createState() => _CompleteInfoState();
}

class _CompleteInfoState extends State<CompleteInfo> {
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  List<Map<String, dynamic>> selectedMembers = [];
  String _errorMessage = '';
  String? selectedActivity = '';
  bool isLoading = false;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void filterMembers(String query) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    setState(() {
      final members = productsProvider.filteredMembers
          .where((member) =>
              member['full_name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<Uint8List> _loadImageFromAssets(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          const SizedBox(height: 12),
          const Text(
            "Complétez les informations",
            textAlign: TextAlign.center,
            style: TextStyle(
              //color: Color(0xFF111928),
              fontSize: 32,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Configurez votre profil",
            textAlign: TextAlign.center,
            style: TextStyle(
              //color: Color(0xFF111928),
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
                    onTap: widget.parameter == "normal" ||
                            widget.parameter == "apple"
                        ? () {
                            _pickImage();
                          }
                        : null,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        shape: BoxShape.circle,
                      ),
                      child: _imageFile == null
                          ? (widget.parameter == "normal" ||
                                  widget.parameter == "apple"
                              ? const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 40,
                                )
                              : ClipOval(
                                  child: Image.network(
                                    Provider.of<AuthService>(context,
                                            listen: false)
                                        .googleAvatar,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ))
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
                CustomTextFormField(
                  controller: _fullnameController,
                  label: "Votre nom complet",
                  isPassword: false,
                  defaultValue: widget.parameter == "normal"
                      ? ""
                      : Provider.of<AuthService>(context, listen: false)
                          .fullnameGoogle,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: IntlPhoneField(
                          
                          showDropdownIcon: false,
                          style: const TextStyle(fontFamily: "Raleway"),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black,
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
                          initialCountryCode: 'TN',
                          pickerDialogStyle: PickerDialogStyle(
                            countryNameStyle: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            countryCodeStyle: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          onChanged: (_) {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          controller: _phoneController,
                          label: "Numéro de téléphone",
                          isPassword: false,
                          keyboardType: TextInputType.numberWithOptions(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _addressController,
                  label: "Addresse",
                  isPassword: false,
                ),
                const SizedBox(height: 16),
                _errorMessage.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : Container(),
                CustomDropdownFormField(
                  label: "Activités",
                  options: const [
                    {"Artiste": "Artiste"},
                    {"Artisan": "Artisan "},
                    {"Autres": "Autres"},
                  ],
                  onChanged: (value) {
                    selectedActivity = value;
                    print(selectedActivity);
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: isLoading ? "Chargement..." : "Créer un compte",
                  textColor: isLoading ? Color(0xFF111928) : Colors.white,
                  buttonColor:
                      isLoading ? Color(0xFFE5E7EB) : Colors.black,
                  onTap: isLoading
                      ? () {}
                      : () async {
                          setState(() {
                            isLoading = true; // Set loading state to true
                          });

                          Uint8List imageToSend;

                          // Vérification des champs
                          if (_fullnameController.text.isEmpty) {
                            setState(() {
                              _errorMessage = "Le nom complet est requis.";
                            });
                            setState(() {
                              isLoading = false; // Reset loading state
                            });
                            return;
                          }

                          if (_phoneController.text.isEmpty) {
                            setState(() {
                              _errorMessage =
                                  "Le numéro de téléphone est requis.";
                            });
                            setState(() {
                              isLoading = false; // Reset loading state
                            });
                            return;
                          }

                          if (_phoneController.text.length != 8 ||
                              !_phoneController.text
                                  .contains(RegExp(r'^[0-9]+$'))) {
                            setState(() {
                              _errorMessage =
                                  "Le numéro de téléphone doit contenir exactement 8 chiffres.";
                            });
                            setState(() {
                              isLoading = false; // Reset loading state
                            });
                            return;
                          }

                          if (_addressController.text.isEmpty) {
                            setState(() {
                              _errorMessage = "L'adresse est requise.";
                            });
                            setState(() {
                              isLoading = false; // Reset loading state
                            });
                            return;
                          }

                          if (_imageFile == null) {
                            imageToSend = await _loadImageFromAssets(
                                'assets/images/user.png');
                          } else {
                            imageToSend = await _imageFile!.readAsBytes();
                          }

                          if (widget.parameter == "normal") {
                            try {
                              final response = await Provider.of<AuthService>(
                                      context,
                                      listen: false)
                                  .registerProfile(
                                    activite: selectedActivity,
                                full_name: _fullnameController.text,
                                phone_number: _phoneController.text,
                                address: _addressController.text,
                                userId: Provider.of<AuthService>(context,
                                        listen: false)
                                    .userId,
                                image: _imageFile,
                              );

                              if (response.statusCode == 200) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LetzGo(parameter: "normal"),
                                  ),
                                );
                              } else {
                                setState(() {
                                  _errorMessage =
                                      "Erreur survenue"; // Affichage du message d'erreur
                                });
                              }
                            } catch (e) {
                              setState(() {
                                _errorMessage =
                                    "Erreur survenue"; // Affichage du message d'erreur
                              });
                            }
                          } else if (widget.parameter == "google") {
                            try {
                              final response = await Provider.of<AuthService>(
                                      context,
                                      listen: false)
                                  .registerProfileGoogle(
                                    activite: selectedActivity,
                                full_name: _fullnameController.text,
                                phone_number: _phoneController.text,
                                address: _addressController.text,
                                userId: Provider.of<AuthService>(context,
                                        listen: false)
                                    .userId,
                              );

                              if (response.statusCode == 200) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LetzGo(parameter: "google"),
                                  ),
                                );
                              } else {
                                setState(() {
                                  _errorMessage =
                                      "Error: ${jsonDecode(response.body)["message"]}";
                                });
                              }
                            } catch (e) {
                              setState(() {
                                _errorMessage = "Erreur dans l'application";
                              });
                            }
                          } else if (widget.parameter == "facebook") {
                            try {
                              final response = await Provider.of<AuthService>(
                                      context,
                                      listen: false)
                                  .registerProfilefacebook(
                                    activite: selectedActivity,
                                full_name: _fullnameController.text,
                                phone_number: _phoneController.text,
                                address: _addressController.text,
                                userId: Provider.of<AuthService>(context,
                                        listen: false)
                                    .userId,
                              );

                              if (response.statusCode == 200) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LetzGo(parameter: "facebook"),
                                  ),
                                );
                              } else {
                                setState(() {
                                  _errorMessage =
                                      "${jsonDecode(response.body)["message"]}";
                                });
                              }
                            } catch (e) {
                              setState(() {
                                _errorMessage = "Erreur dans l'application";
                              });
                            }
                          } else if (widget.parameter == "apple") {
                            try {
                              final response = await Provider.of<AuthService>(
                                      context,
                                      listen: false)
                                  .registerProfileApple(
                                    activite: selectedActivity,
                                image: _imageFile,
                                full_name: _fullnameController.text,
                                phone_number: _phoneController.text,
                                address: _addressController.text,
                                userId: Provider.of<AuthService>(context,
                                        listen: false)
                                    .userId,
                              );

                              if (response.statusCode == 200) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LetzGo(parameter: "apple"),
                                  ),
                                );
                              } else {
                                setState(() {
                                  _errorMessage =
                                      "${jsonDecode(response.body)["message"]}";
                                });
                              }
                            } catch (e) {
                              setState(() {
                                _errorMessage = "Erreur dans l'application";
                              });
                            }
                          }

                          setState(() {
                            isLoading =
                                false; // Reset loading state once the process is finished
                          });
                        },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
