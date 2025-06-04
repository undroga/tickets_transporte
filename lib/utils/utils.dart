import 'package:flutter/material.dart';

class Utils {
  // Método para mostrar SnackBar
  static void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Formatar números de telefone
  static String formatPhone(String phone) {
    if (phone.isEmpty) return '';

    // Remover caracteres não numéricos
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Formatação para número de Moçambique
    if (digits.length == 9) {
      return '${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5)}';
    }

    return phone;
  }

  // Verificar conexão com a internet
  static Future<bool> checkInternetConnection() async {
    try {
      // Aqui você pode implementar uma verificação real de conexão
      // Por exemplo, fazendo uma solicitação ping para um servidor confiável
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Validar endereço de e-mail
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }
}
