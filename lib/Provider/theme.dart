import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadThemePreference() async {
    String? theme = await _storage.read(key: 'isDarkMode');
    if (theme != null) {
      _isDarkMode = theme == 'true';
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storage.write(key: 'isDarkMode', value: _isDarkMode.toString());
    notifyListeners();
  }
}
