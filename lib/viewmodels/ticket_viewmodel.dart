import 'package:flutter/material.dart';
import 'package:tickets_transporte/services/auth_service.dart';
import '../models/ticket.dart';
import '../services/ticket_service.dart';
import '../services/payment_service.dart';

class TicketViewModel extends ChangeNotifier {
  final TicketService _ticketService = TicketService();
  final PaymentService _paymentService = PaymentService();

  List<Ticket> _tickets = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _purchaseInProgress = false;

  List<Ticket> get tickets => _tickets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get purchaseInProgress => _purchaseInProgress;

  Future<void> loadUserTickets(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tickets = await _ticketService.getUserTickets(userId);
    } catch (e) {
      _errorMessage = "Erro ao carregar bilhetes: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Ticket?> purchaseTicket({
    required String userId,
    required String routeId,
    required String fromStop,
    required String toStop,
    required TicketType ticketType,
    required double price,
    required PaymentMethod paymentMethod,
  }) async {
    _purchaseInProgress = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Processar pagamento primeiro
      final paymentResult = await _paymentService.processPayment(
        method: paymentMethod,
        amount: price,
        userId: userId,
      );

      if (!paymentResult.success) {
        _errorMessage = paymentResult.message;
        notifyListeners();
        return null;
      }

      // Se o pagamento for bem-sucedido, criar o bilhete
      final newTicket = await _ticketService.purchaseTicket(
        userId: userId,
        routeId: routeId,
        fromStop: fromStop,
        toStop: toStop,
        ticketType: ticketType,
        price: price,
      );

      // Adicionar à lista de bilhetes
      _tickets.add(newTicket);
      notifyListeners();

      return newTicket;
    } catch (e) {
      _errorMessage = "Erro ao comprar bilhete: ${e.toString()}";
      return null;
    } finally {
      _purchaseInProgress = false;
      notifyListeners();
    }
  }

  Future<bool> validateTicket(String ticketId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _ticketService.validateTicket(ticketId);

      // Atualizar o estado local se o bilhete for validado
      if (result) {
        final index = _tickets.indexWhere((t) => t.id == ticketId);
        if (index >= 0 && _tickets[index].ticketType == TicketType.Single) {
          _tickets[index].status = TicketStatus.Used;
          notifyListeners();
        }
      }

      return result;
    } catch (e) {
      _errorMessage = "Erro ao validar bilhete: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelTicket(String ticketId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _ticketService.cancelTicket(ticketId);

      // Atualizar o estado local se o bilhete for cancelado
      if (result) {
        final index = _tickets.indexWhere((t) => t.id == ticketId);
        if (index >= 0) {
          _tickets[index].status = TicketStatus.Canceled;
          notifyListeners();
        }
      }

      return result;
    } catch (e) {
      _errorMessage = "Erro ao cancelar bilhete: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Ticket> getActiveTickets() {
    return _tickets
        .where((ticket) =>
            ticket.status == TicketStatus.Active && !ticket.isExpired)
        .toList();
  }

  List<Ticket> getHistoricalTickets() {
    return _tickets
        .where((ticket) =>
            ticket.status != TicketStatus.Active || ticket.isExpired)
        .toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
