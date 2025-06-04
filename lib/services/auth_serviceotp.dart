import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  // URL base da sua API - substitua pela URL real
  static const String baseUrl = 'https://sua-api.herokuapp.com/api';

  // Headers padrão para as requisições
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Gerar código OTP de 6 dígitos
  static String generateOTP() {
    Random random = Random();
    String otp = '';
    for (int i = 0; i < 6; i++) {
      otp += random.nextInt(10).toString();
    }
    return otp;
  }

  // Hash da senha usando SHA-256
  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Registrar novo usuário
  static Future<Map<String, dynamic>> registerUser({
    required String nome,
    required String telefone,
    required String email,
    String? senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: headers,
        body: jsonEncode({
          'nome': nome,
          'telefone': telefone,
          'email': email,
          'senha': senha != null ? hashPassword(senha) : null,
          'created_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Usuário registrado com sucesso',
          'data': jsonDecode(response.body),
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Erro ao registrar usuário',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: $e',
      };
    }
  }

  // Enviar OTP via SMS (integração com serviço SMS)
  static Future<Map<String, dynamic>> sendOTP(String telefone) async {
    try {
      String otp = generateOTP();

      // Salvar OTP temporariamente na base de dados
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: headers,
        body: jsonEncode({
          'telefone': telefone,
          'otp': otp,
          'expires_at':
              DateTime.now().add(Duration(minutes: 5)).toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        // Aqui você integraria com um serviço real de SMS
        // Por exemplo: Twilio, Africa's Talking, etc.
        bool smsSent = await _sendSMSViaTwilio(telefone, otp);

        if (smsSent) {
          return {
            'success': true,
            'message': 'Código OTP enviado para $telefone',
          };
        } else {
          return {
            'success': false,
            'message': 'Erro ao enviar SMS',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Erro ao gerar OTP',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: $e',
      };
    }
  }

  // Verificar OTP
  static Future<Map<String, dynamic>> verifyOTP(
      String telefone, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: headers,
        body: jsonEncode({
          'telefone': telefone,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Salvar token de acesso localmente
        await _saveToken(data['token']);
        await _saveUserData(data['user']);

        return {
          'success': true,
          'message': 'Login realizado com sucesso',
          'user': data['user'],
          'token': data['token'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Código OTP inválido',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: $e',
      };
    }
  }

  // Login com email e senha (método alternativo)
  static Future<Map<String, dynamic>> loginWithPassword(
      String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'senha': hashPassword(senha),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        await _saveToken(data['token']);
        await _saveUserData(data['user']);

        return {
          'success': true,
          'message': 'Login realizado com sucesso',
          'user': data['user'],
          'token': data['token'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Credenciais inválidas',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: $e',
      };
    }
  }

  // Buscar dados do usuário
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/auth/user'),
        headers: {
          ...headers,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        await _saveUserData(userData);
        return userData;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Verificar se o usuário está logado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null;
  }

  // Fazer logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  // Salvar token de acesso
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Salvar dados do usuário
  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
  }

  // Obter dados do usuário salvos
  static Future<Map<String, dynamic>?> getSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      return jsonDecode(userDataString);
    }

    return null;
  }

  // Integração com Twilio para envio de SMS (exemplo)
  static Future<bool> _sendSMSViaTwilio(String telefone, String otp) async {
    try {
      // Configurações do Twilio - substitua pelas suas credenciais
      const String accountSid = 'SEU_TWILIO_ACCOUNT_SID';
      const String authToken = 'SEU_TWILIO_AUTH_TOKEN';
      const String twilioNumber = 'SEU_NUMERO_TWILIO';

      String basicAuth = base64Encode(utf8.encode('$accountSid:$authToken'));

      final response = await http.post(
        Uri.parse(
            'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json'),
        headers: {
          'Authorization': 'Basic $basicAuth',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'From': twilioNumber,
          'To': telefone,
          'Body':
              'Seu código de verificação para TicketsTransporteMaputo é: $otp',
        },
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao enviar SMS: $e');
      return false;
    }
  }
}
