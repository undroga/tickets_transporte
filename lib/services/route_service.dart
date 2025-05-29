import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/rotas.dart';
import 'package:tickets_transporte/services/route_service.dart';
import 'package:tickets_transporte/viewmodels/route_viewmodel.dart';

class RouteService {
  // Simula um backend
  List<rotas> _routes = [];

  RouteService() {
    // Pré-carregar rotas para demonstração
    _initializeRoutes();
  }

  void _initializeRoutes() {
    _routes = [
      rotas(
        id: '101',
        name: 'Linha 1 - Baixa-Matola',
        description: 'Rota que liga o centro da cidade à Matola',
        transportType: 'Chapa',
        startPoint: 'Terminal Baixa',
        endPoint: 'Terminal Matola',
        price: 15.0,
        stops: [
          'Terminal Baixa',
          'Museu',
          'Praça da OMM',
          'Mercado Central',
          'Hospital Central',
          'Xipamanine',
          'Terminal Matola',
        ],
        schedule: [
          Schedule(
              weekday: DateFormat.NUM_MONTH_DAY,
              startTime: '05:00',
              endTime: '22:00',
              frequency: DateTime.monday),
        ],
        operator: 'Associação de Transportadores',
        imageUrl: 'assets/images/chapa.jpg',
        start: '',
        end: '',
        color: Colors.black,
        distance: 10,
        type: RouteType.bus,
        duration: 2,
      ),
      rotas(
        id: '102',
        name: 'Linha 2 - Circular',
        description: 'Rota circular pelo centro da cidade',
        transportType: 'TPM',
        startPoint: 'Terminal do Museu',
        endPoint: 'Terminal do Museu',
        price: 10.0,
        stops: [
          'Terminal do Museu',
          'Baixa',
          'Mercado Central',
          'Hospital Central',
          'Praça dos Combatentes',
          'Parque dos Continuadores',
          'Terminal do Museu',
        ],
        schedule: [
          Schedule(
              weekday: DateFormat.NUM_MONTH_DAY,
              startTime: '05:00',
              endTime: '22:00',
              frequency: DateTime.monday),
        ],
        operator: 'Transportes Públicos de Maputo (TPM)',
        imageUrl: 'assets/images/tpm.jpg',
        start: '',
        end: '',
        color: Colors.blue,
        distance: 12,
        type: RouteType.bus,
        duration: 1,
      ),
      rotas(
        id: '103',
        name: 'Linha 3 - Costa do Sol',
        description: 'Rota que liga o centro à praia da Costa do Sol',
        transportType: 'TPM',
        startPoint: 'Terminal Baixa',
        endPoint: 'Costa do Sol',
        price: 12.0,
        stops: [
          'Terminal Baixa',
          'Polana Shopping',
          'Sommerschield',
          'Universidade Eduardo Mondlane',
          'Triunfo',
          'Costa do Sol',
        ],
        schedule: [
          Schedule(
              weekday: DateFormat.NUM_MONTH_DAY,
              startTime: '05:00',
              endTime: '22:00',
              frequency: DateTime.daysPerWeek),
        ],
        operator: 'Transportes Públicos de Maputo (TPM)',
        imageUrl: 'assets/images/tpm.jpg',
        start: '',
        end: '',
        color: Colors.yellow,
        distance: 5,
        type: RouteType.bus,
        duration: 1,
      ),
      rotas(
        id: '104',
        name: 'bus Maputo-Catembe',
        description: 'Transporte terestre entre Maputo e Catembe',
        transportType: 'Buss',
        startPoint: 'Baixa',
        endPoint: 'Catembe',
        price: 25.0,
        stops: [
          'Porto de Maputo',
          'Catembe',
        ],
        schedule: [
          Schedule(
              weekday: DateFormat.NUM_MONTH_DAY,
              startTime: '05:00',
              endTime: '22:00',
              frequency: DateTime.daysPerWeek),
        ],
        operator: '',
        imageUrl: 'assets/images/',
        start: '',
        end: '',
        color: Colors.pinkAccent,
        distance: 15,
        type: RouteType.bus,
        duration: 2,
      ),
    ];
  }

  Future<List<rotas>> getAllRoutes() async {
    // Simulando atraso da rede
    await Future.delayed(Duration(seconds: 1));

    return _routes;
  }

  Future<rotas?> getRouteById(String routeId) async {
    // Simulando atraso da rede
    await Future.delayed(Duration(seconds: 1));

    try {
      return _routes.firstWhere((route) => route.id == routeId);
    } catch (e) {
      return null;
    }
  }

  Future<List<rotas>> searchRoutes(String query) async {
    // Simulando atraso da rede
    await Future.delayed(Duration(seconds: 1));

    query = query.toLowerCase();

    return _routes.where((route) {
      return route.name.toLowerCase().contains(query) ||
          route.description.toLowerCase().contains(query) ||
          route.start.toLowerCase().contains(query) ||
          route.end.toLowerCase().contains(query) ||
          route.stops.any((stop) => stop.toLowerCase().contains(query));
    }).toList();
  }
}
