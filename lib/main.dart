import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_transporte/views/buy_ticket_screen.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';
import 'views/tickets_screen.dart';
import 'views/profile_screen.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/ticket_viewmodel.dart';
import 'viewmodels/route_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
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
        '/home': (context) => const HomeScreen(),
        '/tickets': (context) => const TicketsScreen(),
        '/buy': (context) => const BuyTicketScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
