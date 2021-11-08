import 'package:flutter/material.dart';

class Usuarios with ChangeNotifier {
   late String _nombre = '';

   String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
    notifyListeners();
  }
}