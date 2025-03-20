import 'dart:ffi';
import 'package:flutter/material.dart';
import 'dart:io';

class SellProductProvider extends ChangeNotifier {
  List<File?> _images = List.filled(5, null); // Liste de 5 images initialisées à null
  String? _title; 
  double? _price; 

  // Getters
  List<File?> get images => _images;
  String? get title => _title;
  double? get price => _price;

  // Setters
  void setImage(int index, File image) {
    _images[index] = image;
    notifyListeners();
  }

  void removeImage(int index) {
    _images[index] = null;
    notifyListeners();
  }

  void setTitle(String? value) {
    _title = value;
    notifyListeners();
  }

  void setPrice(String? value) {
    if (value == null || value.isEmpty) {
      _price = null; // Si aucun prix n'est défini, on garde null
    } else {
      try {
        _price = double.parse(value);
      } catch (e) {
        _price = null; // En cas d'erreur de parsing, on met null
      }
    }
    notifyListeners();
  }

  // Méthode pour vérifier si un des champs est rempli
  bool isAnyFieldFilled() {
    return _images.any((image) => image != null) || _title?.isNotEmpty == true || _price != null;
  }

  // Méthode pour réinitialiser toutes les valeurs
  void reset() {
    _images = List.filled(5, null);
    _title = null;
    _price = null;
    notifyListeners();
  }
}
