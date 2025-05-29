import '../models/ticket.dart';

class TicketService {
  // Simula um backend em memória
  List<Ticket> _tickets = [];

  TicketService() {
    // Pré-carregar alguns tickets para demonstração
    _initializeTickets();
  }

  void _initializeTickets() {
    _tickets = [
      Ticket(
        id: '1',
        userId: '1',
        routeId: '101',
        fromStop: 'Terminal do Museu',
        toStop: 'Praça da OMM',
        purchaseDate: DateTime.now().subtract(Duration(days: 2)),
        expiryDate: DateTime.now().add(Duration(days: 5)),
        price: 25.0,
        ticketType: TicketType.Weekly,
        qrCodeData: 'TKT-MAP-001-${DateTime.now().millisecondsSinceEpoch}',
        routeName: 'Museu-OMM',
        validFrom: DateTime.now(),
        validUntil: DateTime.timestamp(),
        isUsed: true,
      ),
      Ticket(
        id: '2',
        userId: '1',
        routeId: '102',
        fromStop: 'Baixa',
        toStop: 'Museu de História Natural',
        purchaseDate: DateTime.now().subtract(Duration(days: 10)),
        expiryDate: DateTime.now().subtract(Duration(days: 9)),
        price: 10.0,
        ticketType: TicketType.Single,
        status: TicketStatus.Used,
        qrCodeData: 'TKT-MAP-002-${DateTime.now().millisecondsSinceEpoch}',
        routeName: 'Museu-OMM',
        validFrom: DateTime.now(),
        validUntil: DateTime.timestamp(),
        isUsed: true,
      ),
      Ticket(
        id: '3',
        userId: '1',
        routeId: '103',
        fromStop: 'Xipamanine',
        toStop: 'Costa do Sol',
        purchaseDate: DateTime.now().subtract(Duration(days: 1)),
        expiryDate: DateTime.now().add(Duration(days: 29)),
        price: 150.0,
        ticketType: TicketType.Monthly,
        qrCodeData: 'TKT-MAP-003-${DateTime.now().millisecondsSinceEpoch}',
        routeName: 'Xipamanine-Costa do Sol',
        validFrom: DateTime.now(),
        validUntil: DateTime.timestamp(),
        isUsed: true,
      ),
    ];
  }

  Future<List<Ticket>> getUserTickets(String userId) async {
    // Simulando atraso da rede
    await Future.delayed(Duration(seconds: 1));

    return _tickets.where((ticket) => ticket.userId == userId).toList();
  }

  Future<Ticket> purchaseTicket({
    required String userId,
    required String routeId,
    required String fromStop,
    required String toStop,
    required TicketType ticketType,
    required double price,
  }) async {
    // Simulando atraso da rede
    await Future.delayed(Duration(seconds: 2));

    // Determinar data de expiração com base no tipo de bilhete
    DateTime expiryDate;
    switch (ticketType) {
      case TicketType.Single:
        expiryDate = DateTime.now().add(Duration(hours: 3));
        break;
      case TicketType.Daily:
        final now = DateTime.now();
        expiryDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case TicketType.Weekly:
        expiryDate = DateTime.now().add(Duration(days: 7));
        break;
      case TicketType.Monthly:
        expiryDate = DateTime.now().add(Duration(days: 30));
        break;
    }

    // Criar novo bilhete
    final newTicket = Ticket(
      id: '${_tickets.length + 1}',
      userId: userId,
      routeId: routeId,
      fromStop: fromStop,
      toStop: toStop,
      purchaseDate: DateTime.now(),
      expiryDate: expiryDate,
      price: price,
      ticketType: ticketType,
      qrCodeData:
          'TKT-MAP-${_tickets.length + 1}-${DateTime.now().millisecondsSinceEpoch}',
      routeName: null,
      validFrom: DateTime.now(),
      validUntil: DateTime.timestamp(),
      isUsed: false,
    );

    // Adicionar à lista de bilhetes
    _tickets.add(newTicket);

    return newTicket;
  }

  Future<bool> validateTicket(String ticketId) async {
    // Simulando atraso da rede
    await Future.delayed(Duration(seconds: 1));

    final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);

    if (ticketIndex >= 0) {
      final ticket = _tickets[ticketIndex];

      // Verificar se o bilhete ainda é válido
      if (ticket.status == TicketStatus.Active && !ticket.isExpired) {
        // Se for bilhete único, marcar como usado
        if (ticket.ticketType == TicketType.Single) {
          _tickets[ticketIndex].status = TicketStatus.Used;
        }
        return true;
      }
    }

    return false;
  }

  Future<bool> cancelTicket(String ticketId) async {
    // Simulando atraso da rede
    await Future.delayed(Duration(seconds: 1));

    final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);

    if (ticketIndex >= 0) {
      _tickets[ticketIndex].status = TicketStatus.Canceled;
      return true;
    }

    return false;
  }
}
