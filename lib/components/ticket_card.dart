import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tickets_transporte/models/ticket.dart';
import 'package:tickets_transporte/services/data_service.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTicketUsed;

  const TicketCard({
    Key? key,
    required this.ticket,
    required this.onTicketUsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isActive = ticket.validUntil.isAfter(now) && !ticket.isUsed;
    final isExpired = ticket.validUntil.isBefore(now) && !ticket.isUsed;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isActive ? Colors.green : Colors.grey,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket.routeName as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ticket.isUsed
                        ? 'Utilizado'
                        : isExpired
                            ? 'Expirado'
                            : 'Ativo',
                    style: TextStyle(
                      color: ticket.isUsed
                          ? Colors.grey
                          : isExpired
                              ? Colors.red
                              : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Validade:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${DateFormat('dd/MM/yyyy').format(ticket.validFrom)} - ${DateFormat('dd/MM/yyyy').format(ticket.validUntil)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Preço:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${ticket.price.toStringAsFixed(2)} MZN',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (isActive)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showUseTicketDialog(context);
                      },
                      child: const Text('Usar Ticket'),
                    ),
                  ),
                if (!isActive && !ticket.isUsed)
                  const SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: null,
                      child: Text('Ticket Expirado'),
                    ),
                  ),
                if (ticket.isUsed)
                  const SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: null,
                      child: Text('Ticket Utilizado'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUseTicketDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usar Ticket'),
        content:
            const Text('Tem certeza que deseja utilizar este ticket agora?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final dataService = DataService();
              await dataService.useTicket(ticket.id);
              Navigator.pop(context);
              onTicketUsed();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Ticket utilizado com sucesso!')),
                );
              }
            },
            child: const Text('Sim, Usar'),
          ),
        ],
      ),
    );
  }
}
