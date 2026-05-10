// ==================== THEME PROVIDER ====================
import 'package:flutter/material.dart';
import 'package:food_delivery_admin/config/admin_theme.dart';

class AdminThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme {
    return _isDarkMode ? AdminTheme.darkTheme : AdminTheme.brightTheme;
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}
