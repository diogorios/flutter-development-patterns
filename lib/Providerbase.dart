import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  String? loggedInUser; // Nome do usuário logado

  void login(String username) {
    loggedInUser = username;
    notifyListeners();
  }

  void logout() {
    loggedInUser = null;
    notifyListeners();
  }
}
