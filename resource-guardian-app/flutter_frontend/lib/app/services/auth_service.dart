import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({required this.token, required this.user});
}

class AuthService {
  static const String _tokenKey = 'auth_token';

  Future<AuthResponse> login(String username, String password) async {
    // Mock login - replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock successful login
    if (username.isNotEmpty && password.isNotEmpty) {
      final user = User(
        id: '1',
        username: username,
        email: '$username@example.com',
        firstName: 'John',
        lastName: 'Doe',
      );
      
      return AuthResponse(
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        user: user,
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<AuthResponse> register(
    String username, 
    String email, 
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    // Mock registration - replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    final user = User(
      id: '1',
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    
    return AuthResponse(
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      user: user,
    );
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
