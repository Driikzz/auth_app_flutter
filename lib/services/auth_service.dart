
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthService {
  // Méthode de hachage des mots de passe
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Tableau associatif local des utilisateurs
  final Map<String, Map<String, dynamic>> _users = {
    'user@example.com': {
      'password': hashPassword('userpass'),
      'firstName': 'Jane',
      'lastName': 'Doe',
      'role': 'User',
    },
    'admin@example.com': {
      'password': hashPassword('adminpass'),
      'firstName': 'Admin',
      'lastName': 'User',
      'role': 'Admin',
    },
  };

  // Méthode de connexion
  Future<Map<String, dynamic>?> login(
      String email,
      String password,
      ) async {
    if (_users.containsKey(email)) {
      String hashedPassword = hashPassword(password);

      if (_users[email]!['password'] == hashedPassword) {
        return {
          'firstName': _users[email]!['firstName'],
          'lastName': _users[email]!['lastName'],
          'role': _users[email]!['role'],
        };
      }
    }

    return null;
  }
}
