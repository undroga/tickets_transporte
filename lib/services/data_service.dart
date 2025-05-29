import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickets_transporte/models/ticket.dart';
import 'package:tickets_transporte/models/user.dart';
import 'package:tickets_transporte/models/rotas.dart';
import 'route_service.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  User? currentUser;
  List<Ticket> tickets = [];
  List<rotas> routes = [];

  Future<void> initData() async {
    await _loadRoutes();
    await _loadUser();
    await _loadTickets();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      currentUser = User.fromJson(jsonDecode(userJson));
    }
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    currentUser = user;
  }

  Future<void> _loadTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final ticketsJson = prefs.getString('tickets');
    if (ticketsJson != null) {
      final List<dynamic> decodedTickets = jsonDecode(ticketsJson);
      tickets = decodedTickets.map((t) => Ticket.fromJson(t)).toList();
    }
  }

  Future<void> saveTicket(Ticket ticket) async {
    tickets.add(ticket);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'tickets', jsonEncode(tickets.map((t) => t.toJson()).toList()));
  }

  Future<void> updateTicket(Ticket updatedTicket) async {
    final index = tickets.indexWhere((t) => t.id == updatedTicket.id);
    if (index >= 0) {
      tickets[index] = updatedTicket;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'tickets', jsonEncode(tickets.map((t) => t.toJson()).toList()));
    }
  }

  Future<void> _loadRoutes() async {
    // Em um aplicativo real, esses dados viriam de uma API
    routes = [
      rotas(
        id: '1',
        name: 'Linha 1',
        start: 'Baixa da Cidade',
        end: 'Matola',
        price: 20.0,
        stops: [
          'Baixa',
          'Museu',
          'Xipamanine',
          'Praça dos Combatentes',
          'Matola'
        ],
        description: '',
        color: Colors.blueAccent,
        schedule: [],
        duration: 8,
        type: RouteType.bus,
        distance: 10,
        transportType: '',
        endPoint: '',
        startPoint: '',
        imageUrl: '',
        operator: '',
      ),
      rotas(
        id: '2',
        name: 'Linha 2',
        start: 'Aeroporto',
        end: 'Costa do Sol',
        price: 15.0,
        stops: [
          'Aeroporto',
          'Avenida Angola',
          'Malhangalene',
          'Polana',
          'Costa do Sol'
        ],
        description: '',
        color: Colors.yellowAccent,
        schedule: [],
        duration: 1,
        type: RouteType.bus,
        distance: 10,
        transportType: '',
        endPoint: '',
        startPoint: '',
        imageUrl: '',
        operator: '',
      ),
      rotas(
        id: '3',
        name: 'Linha 3',
        start: 'Zimpeto',
        end: 'Jardim',
        price: 25.0,
        stops: [
          'Zimpeto',
          'Magoanine',
          'Julius Nyerere',
          'Sommerschield',
          'Jardim'
        ],
        description: '',
        color: Colors.greenAccent,
        schedule: [],
        duration: 2,
        type: RouteType.bus,
        distance: 10,
        transportType: '',
        endPoint: '',
        startPoint: '',
        imageUrl: '',
        operator: '',
      ),
    ];
  }

  List<Ticket> getUserTickets() {
    if (currentUser == null) return [];
    return tickets.where((ticket) => ticket.userId == currentUser!.id).toList();
  }

  List<Ticket> getActiveTickets() {
    if (currentUser == null) return [];
    final now = DateTime.now();
    return tickets
        .where((ticket) =>
            ticket.userId == currentUser!.id &&
            ticket.validUntil.isAfter(now) &&
            !ticket.isUsed)
        .toList();
  }

  Future<void> addBalance(double amount) async {
    if (currentUser != null) {
      currentUser!.balance += amount;
      await saveUser(currentUser!);
    }
  }

  Future<bool> purchaseTicket(
      rotas route, DateTime validFrom, DateTime validUntil) async {
    if (currentUser == null || currentUser!.balance < route.price) {
      return false;
    }

    currentUser!.balance -= route.price;
    await saveUser(currentUser!);

    final newTicket = Ticket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.id,
      routeId: route.id,
      routeName: route.name,
      validFrom: validFrom,
      validUntil: validUntil,
      price: route.price,
      fromStop: '',
      toStop: '',
      purchaseDate: DateTime.now(),
      expiryDate: DateTime.timestamp(),
      ticketType: TicketType.Daily,
      isUsed: false,
    );

    await saveTicket(newTicket);
    return true;
  }

  Future<bool> useTicket(String ticketId) async {
    final index = tickets.indexWhere((t) => t.id == ticketId);
    if (index >= 0 && !tickets[index].isUsed) {
      final updatedTicket = Ticket(
        id: tickets[index].id,
        userId: tickets[index].userId,
        routeId: tickets[index].routeId,
        routeName: tickets[index].routeName,
        validFrom: tickets[index].validFrom,
        validUntil: tickets[index].validUntil,
        price: tickets[index].price,
        isUsed: true,
        fromStop: '',
        toStop: '',
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.timestamp(),
        ticketType: TicketType.Daily,
      );

      await updateTicket(updatedTicket);
      return true;
    }
    return false;
  }
}
