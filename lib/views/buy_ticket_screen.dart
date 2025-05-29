import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tickets_transporte/services/data_service.dart';
import 'package:tickets_transporte/models/rotas.dart';
import 'package:tickets_transporte/models/user.dart';
import 'dart:ui';

class BuyTicketScreen extends StatefulWidget {
  const BuyTicketScreen({Key? key}) : super(key: key);

  @override
  State<BuyTicketScreen> createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  final DataService _dataService = DataService();
  rotas? _selectedRoute;
  int _ticketQuantity = 1;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = _dataService.currentUser;

    var price;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprar Ticket'),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecione a rota',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _dataService.routes.length,
                    itemBuilder: (context, index) {
                      final rotas = _dataService.routes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: _selectedRoute?.id == rotas.id
                            ? Colors.green.withOpacity(0.1)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: _selectedRoute?.id == rotas.id
                              ? const BorderSide(color: Colors.green, width: 2)
                              : BorderSide.none,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedRoute = rotas;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      rotas.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${rotas.price.toStringAsFixed(2)} MZN',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'De ${rotas.start} para ${rotas.end}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Paragens: ${rotas.stops.join(" → ")}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_selectedRoute != null) ...[
                    const Text(
                      'Data de viagem',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 30)),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy').format(_selectedDate),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.calendar_today,
                                  color: Colors.green),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Quantidade',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: _ticketQuantity > 1
                                  ? () {
                                      setState(() {
                                        _ticketQuantity--;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                              color: Colors.green,
                            ),
                            Text(
                              '$_ticketQuantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: _ticketQuantity < 5
                                  ? () {
                                      setState(() {
                                        _ticketQuantity++;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.add_circle_outline),
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Resumo da compra',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Rota:'),
                                Text(_selectedRoute!.name),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Data:'),
                                Text(DateFormat('dd/MM/yyyy')
                                    .format(_selectedDate)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Quantidade:'),
                                Text('$_ticketQuantity'),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${(_selectedRoute!.price * _ticketQuantity).toStringAsFixed(2)} MZN',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Saldo disponível:'),
                                Text(
                                  '${user.balance.toStringAsFixed(2)} MZN',
                                  style: TextStyle(
                                    color: user.balance >=
                                            _selectedRoute!.price *
                                                _ticketQuantity
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ||
                                user.balance <
                                    _selectedRoute!.price * _ticketQuantity
                            ? null
                            : _purchaseTickets,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Finalizar Compra',
                                style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    if (user.balance <
                        _selectedRoute!.price * _ticketQuantity) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Saldo insuficiente para esta compra',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showAddBalanceDialog();
                        },
                        child: const Text('Adicionar saldo'),
                      ),
                    ],
                  ],
                ],
              ),
            ),
    );
  }

  Future<void> _purchaseTickets() async {
    if (_selectedRoute == null) return;

    setState(() {
      _isLoading = true;
    });

    bool allPurchasesSuccessful = true;

    for (int i = 0; i < _ticketQuantity; i++) {
      final validFrom =
          DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      final validUntil = validFrom.add(const Duration(days: 1));

      final success = await _dataService.purchaseTicket(
        _selectedRoute! as rotas,
        validFrom,
        validUntil,
      );

      if (!success) {
        allPurchasesSuccessful = false;
        break;
      }
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (allPurchasesSuccessful) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compra realizada com sucesso!')),
        );

        // Reset selection
        setState(() {
          _selectedRoute = null;
          _ticketQuantity = 1;
          _selectedDate = DateTime.now();
        });

        // Navigate to tickets screen
        if (_dataService.currentUser != null) {
          Navigator.pushNamed(context, '/tickets');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Erro ao processar a compra. Verifique seu saldo.')),
        );
      }
    }
  }

  void _showAddBalanceDialog() {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Saldo'),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Valor (MZN)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                await _dataService.addBalance(amount);
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Saldo adicionado: ${amount.toStringAsFixed(2)} MZN')),
                  );
                }
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}

mixin price {}
