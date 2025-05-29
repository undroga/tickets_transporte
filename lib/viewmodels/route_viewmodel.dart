import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:tickets_transporte/models/rotas.dart';
import 'package:tickets_transporte/services/route_service.dart';

class RouteViewModel extends ChangeNotifier {
  List<rotas> _routes = [];
  List<rotas> get routes => _routes;

  rotas? _selectedRoute;
  rotas? get selectedRoute => _selectedRoute;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  // Controller para busca de rotas
  final TextEditingController searchController = TextEditingController();

  // Construtor
  RouteViewModel() {
    loadRoutes();
    searchController.addListener(() {
      searchRoutes(searchController.text);
    });
  }

  // Carrega todas as rotas
  Future<void> loadRoutes() async {
    _setLoading(true);
    _error = '';

    try {
      // Em um app real, isto seria uma chamada API
      // Simulamos uma pequena latência de rede
      await Future.delayed(const Duration(milliseconds: 500));

      final prefs = await SharedPreferences.getInstance();
      final routesJson = prefs.getString('routes');

      if (routesJson != null && routesJson.isNotEmpty) {
        final List<dynamic> decodedRoutes = jsonDecode(routesJson);
        _routes =
            decodedRoutes.map((r) => rotas.fromJson(r)).cast<rotas>().toList();
      } else {
        // Dados iniciais se não houver rotas salvas
        _initializeDefaultRoutes();
        _saveRoutes();
      }
    } catch (e) {
      _error = 'Erro ao carregar rotas: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Inicializa rotas padrão para Maputo
  void _initializeDefaultRoutes() {
    _routes = [
      rotas(
        id: '1',
        name: 'Linha 1',
        start: 'Baixa da Cidade',
        end: 'Matola',
        price: 20.0,
        description: 'Rota principal ligando o centro de Maputo à Matola',
        stops: [
          'Baixa',
          'Museu',
          'Xipamanine',
          'Praça dos Combatentes',
          'Matola'
        ],
        color: Colors.green,
        type: RouteType.bus,
        schedule: [
          Schedule(
              weekday: 'Segunda-Sexta',
              startTime: '05:00',
              endTime: '22:00',
              frequency: 15),
          Schedule(
              weekday: 'Sábado',
              startTime: '06:00',
              endTime: '20:00',
              frequency: 20),
          Schedule(
              weekday: 'Domingo',
              startTime: '07:00',
              endTime: '19:00',
              frequency: 30),
        ],
        distance: 12.5,
        duration: 45,
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
        description: 'Rota litorânea ligando o aeroporto à praia',
        stops: [
          'Aeroporto',
          'Avenida Angola',
          'Malhangalene',
          'Polana',
          'Costa do Sol'
        ],
        color: Colors.blue,
        type: RouteType.bus,
        schedule: [
          Schedule(
              weekday: 'Segunda-Sexta',
              startTime: '06:00',
              endTime: '21:00',
              frequency: 20),
          Schedule(
              weekday: 'Sábado',
              startTime: '07:00',
              endTime: '21:00',
              frequency: 25),
          Schedule(
              weekday: 'Domingo',
              startTime: '08:00',
              endTime: '20:00',
              frequency: 35),
        ],
        distance: 8.7,
        duration: 30,
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
        description: 'Rota que conecta a zona norte à zona nobre',
        stops: [
          'Zimpeto',
          'Magoanine',
          'Julius Nyerere',
          'Sommerschield',
          'Jardim'
        ],
        color: Colors.orange,
        type: RouteType.bus,
        schedule: [
          Schedule(
              weekday: 'Segunda-Sexta',
              startTime: '05:30',
              endTime: '22:30',
              frequency: 15),
          Schedule(
              weekday: 'Sábado',
              startTime: '06:30',
              endTime: '21:30',
              frequency: 20),
          Schedule(
              weekday: 'Domingo',
              startTime: '07:30',
              endTime: '20:30',
              frequency: 30),
        ],
        distance: 15.3,
        duration: 55,
        transportType: '',
        endPoint: '',
        startPoint: '',
        imageUrl: '',
        operator: '',
      ),
      rotas(
        id: '4',
        name: 'Expresso Maputo-Marracuene',
        start: 'Maputo',
        end: 'Marracuene',
        price: 35.0,
        description: 'Serviço expresso para Marracuene com poucas paragens',
        stops: ['Terminal Central Maputo', 'Laulane', 'Marracuene'],
        color: Colors.red,
        type: RouteType.express,
        schedule: [
          Schedule(
              weekday: 'Segunda-Sexta',
              startTime: '06:00',
              endTime: '20:00',
              frequency: 30),
          Schedule(
              weekday: 'Sábado',
              startTime: '07:00',
              endTime: '19:00',
              frequency: 45),
          Schedule(
              weekday: 'Domingo',
              startTime: '08:00',
              endTime: '18:00',
              frequency: 60),
        ],
        distance: 21.0,
        duration: 40,
        transportType: '',
        endPoint: '',
        startPoint: '',
        imageUrl: '',
        operator: '',
      ),
      rotas(
        id: '5',
        name: 'Circular Urbana',
        start: 'Baixa',
        end: 'Baixa',
        price: 12.0,
        description: 'Rota circular pelo centro da cidade',
        stops: [
          'Baixa',
          'Mercado Central',
          'Avenida Eduardo Mondlane',
          'Avenida 24 de Julho',
          'Baixa'
        ],
        color: Colors.purple,
        type: RouteType.circular,
        schedule: [
          Schedule(
              weekday: 'Segunda-Sexta',
              startTime: '06:00',
              endTime: '20:00',
              frequency: 10),
          Schedule(
              weekday: 'Sábado',
              startTime: '07:00',
              endTime: '19:00',
              frequency: 15),
          Schedule(
              weekday: 'Domingo',
              startTime: '08:00',
              endTime: '18:00',
              frequency: 20),
        ],
        distance: 7.5,
        duration: 35,
        transportType: '',
        endPoint: '',
        startPoint: '',
        imageUrl: '',
        operator: '',
      ),
    ];
  }

  // Salva as rotas no armazenamento local
  Future<void> _saveRoutes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'routes', jsonEncode(_routes.map((r) => r.toJson()).toList()));
    } catch (e) {
      _error = 'Erro ao salvar rotas: ${e.toString()}';
      notifyListeners();
    }
  }

  // Seleciona uma rota específica
  void selectRoute(String routeId) {
    _selectedRoute = _routes.firstWhere(
      (route) => route.id == routeId,
      orElse: () => throw Exception('Rota não encontrada: $routeId'),
    ) as rotas?;
    notifyListeners();
  }

  // Limpa a seleção atual
  void clearSelection() {
    _selectedRoute = null;
    notifyListeners();
  }

  // Busca rotas por nome, origem ou destino
  void searchRoutes(String query) {
    if (query.isEmpty) {
      loadRoutes();
      return;
    }

    _setLoading(true);

    final lowercaseQuery = query.toLowerCase();
    try {
      final tempRoutes = _routes.where((route) {
        return route.name.toLowerCase().contains(lowercaseQuery) ||
            route.start.toLowerCase().contains(lowercaseQuery) ||
            route.end.toLowerCase().contains(lowercaseQuery) ||
            route.stops
                .any((stop) => stop.toLowerCase().contains(lowercaseQuery));
      }).toList();

      _routes = tempRoutes;
    } catch (e) {
      _error = 'Erro na busca: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Adiciona uma nova rota
  Future<bool> addRoute(rotas newRoute) async {
    _setLoading(true);
    _error = '';

    try {
      // Verifica se o ID já existe
      if (_routes.any((rotas) => rotas.id == newRoute.id)) {
        _error = 'Já existe uma rota com este ID';
        return false;
      }

      _routes.add(newRoute);
      await _saveRoutes();
      return true;
    } catch (e) {
      _error = 'Erro ao adicionar rota: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Atualiza uma rota existente
  Future<bool> updateRoute(rotas updatedRoute) async {
    _setLoading(true);
    _error = '';

    try {
      final index = _routes.indexWhere((rotas) => rotas.id == updatedRoute.id);
      if (index == -1) {
        _error = 'Rota não encontrada';
        return false;
      }

      _routes[index] = updatedRoute;
      await _saveRoutes();

      // Atualiza a rota selecionada se for a mesma
      if (_selectedRoute?.id == updatedRoute.id) {
        _selectedRoute = updatedRoute as rotas?;
      }

      return true;
    } catch (e) {
      _error = 'Erro ao atualizar rota: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Remove uma rota
  Future<bool> deleteRoute(String routeId) async {
    _setLoading(true);
    _error = '';

    try {
      final index = _routes.indexWhere((rotas) => rotas.id == routeId);
      if (index == -1) {
        _error = 'Rota não encontrada';
        return false;
      }

      _routes.removeAt(index);
      await _saveRoutes();

      // Limpa a seleção se for a rota removida
      if (_selectedRoute?.id == routeId) {
        _selectedRoute = null;
      }

      return true;
    } catch (e) {
      _error = 'Erro ao remover rota: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Filtra rotas por tipo
  List<rotas> getRoutesByType(RouteType type) {
    return _routes.where((rotas) => rotas.type == type).toList();
  }

  // Obtém as rotas mais populares (simulado)
  List<rotas> getPopularRoutes() {
    // Em um app real, isso poderia ser baseado em dados de uso
    // Aqui apenas retornamos as 3 primeiras rotas como "populares"
    return _routes.take(3).toList();
  }

  // Obtém rotas por faixa de preço
  List<rotas> getRoutesByPriceRange(double minPrice, double maxPrice) {
    return _routes
        .where((rotas) => rotas.price >= minPrice && rotas.price <= maxPrice)
        .toList();
  }

  // Calcula o tempo médio de viagem para todas as rotas
  double getAverageTravelTime() {
    if (_routes.isEmpty) return 0;
    final totalDuration =
        _routes.fold(0.0, (sum, route) => sum + route.duration);
    return totalDuration / _routes.length;
  }

  // Define o estado de carregamento e notifica os ouvintes
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
