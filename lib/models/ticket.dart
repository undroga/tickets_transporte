import 'dart:convert';
import 'dart:ui';
import 'package:tickets_transporte/models/rotas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TicketType { Single, Daily, Weekly, Monthly }

enum TicketStatus { Active, Used, Expired, Canceled }

class Ticket {
  final String id;
  final String userId;
  final String routeId;
  final String fromStop;
  final String toStop;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final double price;
  final TicketType ticketType;
  TicketStatus status;
  String? qrCodeData;

  Ticket({
    required this.id,
    required this.userId,
    required this.routeId,
    required this.fromStop,
    required this.toStop,
    required this.purchaseDate,
    required this.expiryDate,
    required this.price,
    required this.ticketType,
    this.status = TicketStatus.Active,
    this.qrCodeData,
    required routeName,
    required DateTime validFrom,
    required DateTime validUntil,
    required bool isUsed,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      userId: json['userId'],
      routeId: json['routeId'],
      fromStop: json['fromStop'],
      toStop: json['toStop'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      price: json['price'].toDouble(),
      ticketType: TicketType.values.byName(json['ticketType']),
      status: TicketStatus.values.byName(json['status']),
      qrCodeData: json['qrCodeData'],
      routeName: json['routeName'],
      validFrom: json['DateTime'],
      validUntil: json['DateTime'],
      isUsed: json['DateTime'],
    );
  }

  get validUntil => DateTime.timestamp();

  bool get isUsed => true;

  rotas get routeName => rotas.fromJson(json as Map<String, dynamic>);

  DateTime get validFrom => DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'routeId': routeId,
      'fromStop': fromStop,
      'toStop': toStop,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'price': price,
      'ticketType': ticketType.name,
      'status': status.name,
      'qrCodeData': qrCodeData,
    };
  }

  String get formattedPurchaseDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(purchaseDate);
  }

  String get formattedExpiryDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(expiryDate);
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiryDate);
  }

  String get ticketTypeDisplay {
    switch (ticketType) {
      case TicketType.Single:
        return "Bilhete Único";
      case TicketType.Daily:
        return "Passe Diário";
      case TicketType.Weekly:
        return "Passe Semanal";
      case TicketType.Monthly:
        return "Passe Mensal";
      default:
        return "Desconhecido";
    }
  }

  String get statusDisplay {
    switch (status) {
      case TicketStatus.Active:
        return "Ativo";
      case TicketStatus.Used:
        return "Utilizado";
      case TicketStatus.Expired:
        return "Expirado";
      case TicketStatus.Canceled:
        return "Cancelado";
      default:
        return "Desconhecido";
    }
  }

  Color get statusColor {
    switch (status) {
      case TicketStatus.Active:
        return Colors.green;
      case TicketStatus.Used:
        return Colors.blue;
      case TicketStatus.Expired:
        return Colors.red;
      case TicketStatus.Canceled:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
