import 'package:flutter/material.dart';

import '../services/data_service.dart';
import '../components/ticket_card.dart';
import '../services/ticket_service.dart';
import '../models/ticket.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTickets = _dataService.getUserTickets();
    final now = DateTime.now();

    final activeTickets = allTickets
        .where((ticket) => ticket.validUntil.isAfter(now) && !ticket.isUsed)
        .toList();

    final historyTickets = allTickets
        .where((ticket) => ticket.validUntil.isBefore(now) || ticket.isUsed)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Tickets'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Ativos'),
            Tab(text: 'Histórico'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTicketList(activeTickets, isActive: true),
          _buildTicketList(historyTickets, isActive: false),
        ],
      ),
    );
  }

  Widget _buildTicketList(List<Ticket> tickets, {required bool isActive}) {
    if (tickets.isEmpty) {
      return Center(
        child: Text(
          isActive
              ? 'Você não possui tickets ativos'
              : 'Seu histórico de tickets está vazio',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _dataService.initData();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return TicketCard(
            ticket: tickets[index],
            onTicketUsed: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
