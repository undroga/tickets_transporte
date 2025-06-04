import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tickets_transporte/views/buy_ticket_screen.dart';
import 'package:tickets_transporte/views/dashboard_screen.dart';
import 'package:tickets_transporte/views/profile_screen.dart';
import 'package:tickets_transporte/views/route_detail_screen.dart';
import 'package:tickets_transporte/views/tickets_screen.dart';
import 'package:tickets_transporte/models/rotas.dart';
import '../widgets/custom_header.dart';
import '../widgets/route_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // Dados simulados das rotas
  final List<rotas> _routes = [
    rotas(
      id: '1',
      name: 'Linha 1 - Centro/Costa do Sol',
      color: const Color(0xFFEF4444),
      price: 15,
      start: '',
      end: '',
      description: '',
      stops: [],
      type: RouteType.bus,
      schedule: [],
      distance: 10,
      duration: 30,
      transportType: '',
      endPoint: '',
      startPoint: '',
      imageUrl: '',
      operator: '',
    ),
    rotas(
      id: '2',
      name: 'Linha 2 - Baixa/Matola',
      color: const Color(0xFF06B6D4),
      price: 15,
      start: '',
      end: '',
      description: '',
      stops: [],
      type: RouteType.bus,
      schedule: [],
      distance: 10,
      duration: 30,
      transportType: '',
      endPoint: '',
      startPoint: '',
      imageUrl: '',
      operator: '',
    ),
    rotas(
      id: '3',
      name: 'Linha 3 - Sommerschield/Aeroporto',
      color: const Color(0xFF3B82F6),
      price: 15,
      start: '',
      end: '',
      description: '',
      stops: [],
      type: RouteType.bus,
      schedule: [],
      distance: 10,
      duration: 30,
      transportType: '',
      endPoint: '',
      startPoint: '',
      imageUrl: '',
      operator: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(
        title: 'Transporte Maputo',
        showBack: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchSection(),
            _buildQuickActions(),
            _buildPopularRoutes(),
            const SizedBox(height: 80), // Espaço para navegação inferior
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Para onde quer ir?',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) {
                // Implementar pesquisa
                _handleSearch(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  icon: Icons.directions_bus,
                  label: 'Ver Rotas',
                  onPressed: () => _navigateToRoutes(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.location_on,
                  label: 'Paragens Próximas',
                  onPressed: () => _navigateToNearbyStops(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularRoutes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rotas Populares',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _routes.length,
            itemBuilder: (context, index) {
              return RouteCard(
                route: _routes[index],
                onTap: () => _navigateToRouteDetail(_routes[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Já está na tela inicial
        break;
      case 1:
        _navigateToRoutes();
        break;
      case 2:
        _navigateToTickets();
        break;
      case 3:
        _navigateToProfile();
        break;
    }
  }

  void _handleSearch(String query) {
    // Implementar lógica de pesquisa
    print('Pesquisando por: $query');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesquisando por: $query'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToRoutes() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RouteDetailScreen(
                  route: rotas.fromJson(json as Map<String, dynamic>),
                )));
    print('Navegando para Rotas');
  }

  void _navigateToNearbyStops() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => NearbyStopsScreen()));
    print('Navegando para Paragens Próximas');
  }

  void _navigateToRouteDetail(rotas route) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetailScreen(route: route)));
    print('Navegando para detalhes da rota: ${route.name}');
  }

  void _navigateToTickets() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TicketsScreen()));
    print('Navegando para Bilhetes');
  }

  void _navigateToProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    print('Navegando para Perfil');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

final List<Widget> _screens = [
  const DashboardScreen(),
  const TicketsScreen(),
  const BuyTicketScreen(),
  const ProfileScreen(),
];

@override
Widget build(BuildContext context) {
  int _selectedIndex = 0;
  return Scaffold(
    body: _screens[_selectedIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number),
          label: 'Tickets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Comprar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    ),
  );
}

void setState(Null Function() param0) {}
