import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Models/virement.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/virement.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:finesse_frontend/Widgets/CustomTextField/customTextField.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BankTransferForm extends StatefulWidget {
  const BankTransferForm({super.key});

  @override
  _BankTransferFormState createState() => _BankTransferFormState();
}

class _BankTransferFormState extends State<BankTransferForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _bicController = TextEditingController();
  final TextEditingController _ribController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Charge les virements lors de l'initialisation
    _loadVirements();
  }

  Future<void> _loadVirements() async {
    // Assurez-vous que l'API est appelée uniquement après la construction du widget
    await Future.delayed(Duration(milliseconds: 100)); // Pour être sûr que le widget est construit
    await Provider.of<VirementProvider>(context, listen: false).fetchVirements(
      Provider.of<AuthService>(context, listen: false).currentUser!.id
    );

    // Récupérer les détails des virements et les pré-remplir dans les champs
    final bankDetails = Provider.of<VirementProvider>(context, listen: false).virements;
    if (bankDetails.isNotEmpty) {
      _nameController.text = bankDetails[0].nomComplet;
      _bankNameController.text = bankDetails[0].banque;
      _ibanController.text = bankDetails[0].iban;
      _bicController.text = bankDetails[0].bicSwift;
      _ribController.text = bankDetails[0].rib;
      _countryController.text = bankDetails[0].pays;
    }
  }

  // Fonction pour soumettre le formulaire
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var formData = {
        'user_id': Provider.of<AuthService>(context, listen: false).currentUser!.id,
        'nom_complet': _nameController.text,
        'banque': _bankNameController.text,
        'iban': _ibanController.text,
        'bic_swift': _bicController.text,
        'rib': _ribController.text,
        'pays': _countryController.text,
      };

      String jsonData = jsonEncode(formData);
      try {
        final response = await http.post(
          Uri.parse('${AppConfig.baseUrl}/api/auth/create_virement/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonData,
        );

        if (response.statusCode == 201) {
          print("Virement créé avec succès");
          // Mettez à jour les virements dans le provider
          await Provider.of<VirementProvider>(context, listen: false).fetchVirements(
              Provider.of<AuthService>(context, listen: false).currentUser!.id);

          // Vous pouvez afficher une alerte ou naviguer vers une autre page
        } else {
          print("Erreur lors de la création du virement: ${response.body}");
        }
      } catch (e) {
        print("Erreur lors de la connexion: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Le formulaire n'est pas valide");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bankDetails = Provider.of<VirementProvider>(context).virements;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Coordonnées Bancaires",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: 0.50,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: _nameController,
                validator: (value) => value!.isEmpty ? "Entrez votre nom" : null,
                isPassword: false,
                label: 'Nom complet',
              ),
              SizedBox(height: 8),
              CustomTextFormField(
                controller: _bankNameController,
                validator: (value) =>
                    value!.isEmpty ? "Entrez le nom de votre banque" : null,
                isPassword: false,
                label: 'Nom de la banque',
              ),
              SizedBox(height: 8),
              // Afficher IBAN et BIC/SWIFT sur la même ligne
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _ibanController,
                      validator: (value) => value!.length < 15 ? "IBAN invalide" : null,
                      isPassword: false,
                      label: 'IBAN',
                    ),
                  ),
                  SizedBox(width: 8), // Espace entre les deux champs
                  Expanded(
                    child: CustomTextFormField(
                      controller: _bicController,
                      validator: (value) =>
                          value!.length < 8 ? "BIC/SWIFT invalide" : null,
                      isPassword: false,
                      label: 'BIC/SWIFT',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              CustomTextFormField(
                controller: _ribController,
                validator: (value) =>
                    value!.length < 20 ? "RIB invalide (min. 20 caractères)" : null,
                isPassword: false,
                label: 'RIB',
              ),
              SizedBox(height: 8),
              CustomTextFormField(
                controller: _countryController,
                validator: (value) => value!.isEmpty ? "Entrez le pays" : null,
                isPassword: false,
                label: 'Pays',
              ),
              SizedBox(height: 8),
              SizedBox(height: 20),
              CustomButton(
                label: _isLoading ? "Enregistrement..." : "Enregistrer",
                onTap: _isLoading
                    ? () {}
                    : () {
                        _submitForm();
                      },
                textColor: Colors.white,
                buttonColor: _isLoading ? Colors.grey : Color(0xFFC668AA),
              )
            ],
          ),
        ),
      ),
    );
  }
}
