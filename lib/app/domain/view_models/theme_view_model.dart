import 'package:flutter/material.dart';

class ThemeViewModel extends ChangeNotifier {
  Brightness theme = Brightness.light;
  void toggleTheme() {
    theme = theme == Brightness.light ? Brightness.dark : Brightness.light;
    notifyListeners();
  }
}
