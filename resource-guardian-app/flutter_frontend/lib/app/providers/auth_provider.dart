import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  String? _token;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _loadSavedAuth();
  }

  Future<void> _loadSavedAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedToken = await _authService.getSavedToken();
      if (savedToken != null) {
        _token = savedToken;
        // In a real app, you'd validate the token and get user data
        _isAuthenticated = true;
      }
    } catch (e) {
      debugPrint('Error loading saved auth: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authResponse = await _authService.login(username, password);
      _user = authResponse.user;
      _token = authResponse.token;
      _isAuthenticated = true;
      
      await _authService.saveToken(authResponse.token);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String username, String email, String password, {String? firstName, String? lastName}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authResponse = await _authService.register(
        username, 
        email, 
        password,
        firstName: firstName,
        lastName: lastName,
      );
      _user = authResponse.user;
      _token = authResponse.token;
      _isAuthenticated = true;
      
      await _authService.saveToken(authResponse.token);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Register error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _isAuthenticated = false;
    
    await _authService.clearToken();
    
    notifyListeners();
  }
}
