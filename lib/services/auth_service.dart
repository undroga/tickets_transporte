import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  // Simulação de backend para fins de demonstração
  Future<User?> login(String email, String password) async {
    // Simulando atraso da rede
    await Future.delayed(Duration(seconds: 2));

    // Verificação básica - em uma app real seria validado com backend
    if (email == 'user@example.com' && password == 'password123') {
      // Usuário exemplo
      final user = User(
        id: '1',
        name: 'João Matsinhe',
        email: email,
        phoneNumber: '+258 84 123 4567',
        balance: 20,
        profileImageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      );

      // Salvar no armazenamento local
      await _saveUserLocally(user);

      return user;
    }

    return null;
  }

  Future<bool> register(
      String name, String email, String password, String phoneNumber) async {
    // Simulando atraso da rede
    await Future.delayed(Duration(seconds: 2));

    // Em uma app real, enviaria dados para o backend e receberia resposta
    return true;
  }

  Future<bool> logout() async {
    // Simulando atraso da rede
    await Future.delayed(Duration(seconds: 1));

    // Limpar dados locais
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    return true;
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }

    return null;
  }

  Future<void> _saveUserLocally(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }
}
