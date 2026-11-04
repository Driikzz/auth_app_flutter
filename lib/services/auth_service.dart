
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import 'token_storage_service.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000';

  final TokenStorageService _tokenStorage =
  TokenStorageService();

  // Connexion de l'utilisateur
  Future<UserModel?> login(
      String email,
      String password,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final data =
    jsonDecode(response.body) as Map<String, dynamic>;

    if (data['status'] != 200 ||
        data['token'] is! String ||
        (data['token'] as String).isEmpty) {
      return null;
    }

    // Convertir le JSON en UserModel
    final user = UserModel.fromJson(data);

    // Sauvegarder le token de manière sécurisée
    await _tokenStorage.saveToken(
      data['token'] as String,
    );

    return user;
  }
  Future<String?> getToken() async {
    return await _tokenStorage.getToken();
  }
  // Récupérer l'utilisateur via une route protégée
  Future<UserModel?> getCurrentUser() async {
    final token = await _tokenStorage.getToken();

    if (token == null) {
      return null;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      return null;
    }

    final data =
    jsonDecode(response.body) as Map<String, dynamic>;

    return UserModel.fromJson(data);
  }

  // Déconnexion : supprimer le token
  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }
}
