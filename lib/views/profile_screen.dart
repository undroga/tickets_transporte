import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickets_transporte/services/data_service.dart';
import 'package:tickets_transporte/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    var user = _dataService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: user != user
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Saldo: ${user.balance.toStrin(2)} MZN',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
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
                        children: [
                          ListTile(
                            leading:
                                const Icon(Icons.email, color: Colors.green),
                            title: const Text('Email'),
                            subtitle: Text(user.email),
                          ),
                          const Divider(),
                          ListTile(
                            leading:
                                const Icon(Icons.phone, color: Colors.green),
                            title: const Text('Telefone'),
                            subtitle: Text(user.phoneNumber),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.confirmation_number,
                                color: Colors.green),
                            title: const Text('Total de tickets'),
                            subtitle:
                                Text('${_dataService.getUserTickets().length}'),
                            onTap: () {
                              Navigator.pushNamed(context, '/tickets');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet,
                        color: Colors.green),
                    title: const Text('Adicionar Saldo'),
                    onTap: () {
                      _showAddBalanceDialog();
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.help_outline, color: Colors.green),
                    title: const Text('Ajuda e Suporte'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Funcionalidade a ser implementada')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.green),
                    title: const Text('Configurações'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Funcionalidade a ser implementada')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.red),
                    title: const Text('Sair'),
                    onTap: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sair da conta'),
                          content: const Text('Tem certeza que deseja sair?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Sair'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );

                      if (result ?? false) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('user');
                        if (mounted) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
    );
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
