import 'dart:convert';
import 'package:finesse_frontend/ApiServices/backend_url.dart';
import 'package:finesse_frontend/Provider/AuthService.dart';
import 'package:finesse_frontend/Provider/theme.dart';
import 'package:finesse_frontend/Widgets/AuthButtons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Vacance extends StatefulWidget {
  const Vacance({super.key});

  @override
  State<Vacance> createState() => _VacanceState();
}

class _VacanceState extends State<Vacance> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _errorMessage; // Variable pour stocker les messages d'erreur

  bool _isLoading = false; // Indicateur de chargement
  bool _isSuccess = false; // Indicateur de succès
  bool _isFailed = false; // Indicateur d'échec

  // Fonction pour sélectionner une date via le DatePicker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
        return Theme(
          data: isDarkMode
              ? ThemeData.dark().copyWith(
                  primaryColor: Color.fromARGB(255, 249, 217, 144),
                  hintColor: Color.fromARGB(255, 249, 217, 144),
                  dialogBackgroundColor: Colors.grey[800],
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                )
              : ThemeData.light().copyWith(
                  primaryColor: Color(0xFFFB98B7),
                  hintColor: Color(0xFFFB98B7),
                  dialogBackgroundColor: Colors.white,
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                  ),
                ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = "${_startDate!.toLocal()}".split(' ')[0];
        } else {
          _endDate = picked;
          _endDateController.text = "${_endDate!.toLocal()}".split(' ')[0];
        }
      });
    }
  }

  // Fonction pour envoyer la requête POST à l'API Django
  Future<void> _activateVacationMode() async {
    if (_startDate != null && _endDate != null) {
      setState(() {
        _isLoading = true;
        _isSuccess = false;
        _isFailed = false;
        _errorMessage = null; // Réinitialiser le message d'erreur
      });

      final url =
          '${AppConfig.baseUrl}/api/auth/set_vacation/'; // Remplacez par l'URL de votre API Django
      String userId = Provider.of<AuthService>(context, listen: false)
          .currentUser!
          .id
          .toString(); // Remplacez par l'ID de l'utilisateur actuellement connecté

      final response = await http.post(
        Uri.parse(url),
        body: {
          'user_id': userId,
          'vacation_start_date':
              _startDate!.toIso8601String().split('T')[0], // format YYYY-MM-DD
          'vacation_end_date':
              _endDate!.toIso8601String().split('T')[0], // format YYYY-MM-DD
        },
      );

      setState(() {
        _isLoading = false;
        if (response.statusCode == 200) {
          _isSuccess = true;
          _errorMessage = "Mode vacances activé avec succès !";
        } else {
          _isFailed = true;
          _errorMessage = "Échec de l'activation du mode vacances";
        }
      });
    } else {
      // Si les dates ne sont pas sélectionnées
      setState(() {
        _isFailed = true;
        _isLoading = false;
        _errorMessage = "Veuillez sélectionner les dates.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text("Mode Vacances")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mode Vacances :\n"
              "Lorsque vous activez ce mode, vous ne serez pas notifié et certaines personnes "
              "ne pourront pas commander vos produits.",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway'),
            ),
            const SizedBox(height: 20),

            // Sélection de la date de début
            const Text("Date de début des vacances",
                style: TextStyle(fontSize: 16, fontFamily: 'Raleway')),
            TextFormField(
              controller: _startDateController,
              decoration: const InputDecoration(
                hintText: "Choisissez une date",
                hintStyle: TextStyle(fontFamily: 'Raleway'),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, true),
            ),
            const SizedBox(height: 20),

            // Sélection de la date de fin
            const Text("Date de fin des vacances",
                style: TextStyle(fontSize: 16, fontFamily: 'Raleway')),
            TextFormField(
              controller: _endDateController,
              decoration: const InputDecoration(
                hintText: "Choisissez une date",
                hintStyle: TextStyle(fontFamily: 'Raleway'),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 40),

            // Bouton pour activer le mode vacances
            CustomButton(
              onTap: _isLoading ? () {} : _activateVacationMode,
              label: _isLoading
                  ? "Chargement..."
                  : _isSuccess
                      ? "Mode Vacances Activé"
                      : _isFailed
                          ? "Échec"
                          : "Activer le mode vacances",
              buttonColor: _isSuccess
                  ? Colors.green
                  : _isFailed
                      ? Colors.red
                      : Colors.blue,
              textColor: Colors.white,
            ),

            // Affichage du message d'erreur ou succès en texte rouge
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
