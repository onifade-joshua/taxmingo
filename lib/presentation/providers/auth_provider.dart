import 'package:flutter/material.dart';
import '../../data/models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock authentication logic
    if (email.isNotEmpty && password.length >= 6) {
      _currentUser = User(
        id: '1',
        fullName: 'John Doe',
        email: email,
        phoneNumber: '+2348123456789',
        createdAt: DateTime.now(),
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signup(
    String fullName,
    String email,
    String phoneNumber,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock registration logic
    if (fullName.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    // Simulate checking stored auth token
    await Future.delayed(const Duration(seconds: 1));

    // For demo purposes, user is not authenticated by default
    _isAuthenticated = false;
    notifyListeners();
  }
}
