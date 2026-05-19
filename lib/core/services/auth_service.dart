import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';

class AuthService extends ChangeNotifier {
  static const _validUser = UserProfile(
    username: 'Jos_robles',
    firstName: 'Josmartin',
    lastName: 'Robles Sánchez',
    age: 21,
    gender: 'Hombre',
    interests: ['Cultura', 'Gastronomía', 'Naturaleza', 'Playa'],
    defaultBudget: 5000,
  );

  UserProfile? _currentUser;
  String? _error;

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  String? get error => _error;

  bool login(String username, String password) {
    if (username.trim() == _validUser.username && password == 'password123') {
      _currentUser = _validUser;
      _error = null;
      notifyListeners();
      return true;
    }
    _error = 'Usuario o contraseña incorrectos';
    notifyListeners();
    return false;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }
}
