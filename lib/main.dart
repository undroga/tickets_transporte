import 'package:flutter/material.dart';
import 'package:tickets_transporte/views/buy_ticket_screen.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';
import 'views/tickets_screen.dart';
import 'views/profile_screen.dart';
import 'package:tickets_transporte/views/signup_screen.dart';
import 'package:tickets_transporte/views/otp_verification_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MaputoTransporteApp());
}

class MaputoTransporteApp extends StatelessWidget {
  const MaputoTransporteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maputo Transporte',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'MZ'),
        Locale('en', 'US'),
      ],
      home: const LoginScreen(),
      routes: {
        '/otp-verification': (context) => const OTPVerificationScreen(
              telefone: '', // Será passado via argumentos
            ),
        '/home': (context) => const HomeScreen(),
        '/tickets': (context) => const TicketsScreen(),
        '/buy': (context) => const BuyTicketScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
