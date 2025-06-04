import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/custom_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/user_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dados simulados do usuário
  final User _currentUser = User(
    name: 'João Silva',
    email: 'joao.silva@email.com',
    profileImageUrl: null, id: '', phoneNumber: '',
    balance: 10, // Pode adicionar URL da foto aqui
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
        title: 'Meu Perfil',
        showBack: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserInfoSection(),
            const SizedBox(height: 20),
            _buildMenuSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          UserAvatar(
            name: _currentUser.name,
            profileImageUrl: _currentUser.profileImageUrl,
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            _currentUser.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _currentUser.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _editProfile,
            child: Text(
              'Editar Perfil',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.credit_card,
            title: 'Métodos de Pagamento',
            onTap: _navigateToPaymentMethods,
          ),
          ProfileMenuItem(
            icon: Icons.history,
            title: 'Histórico de Viagens',
            onTap: _navigateToTravelHistory,
          ),
          ProfileMenuItem(
            icon: Icons.notifications,
            title: 'Notificações',
            onTap: _navigateToNotifications,
          ),
          ProfileMenuItem(
            icon: Icons.star,
            title: 'Avaliar App',
            onTap: _rateApp,
          ),
          ProfileMenuItem(
            icon: Icons.help,
            title: 'Ajuda e Suporte',
            onTap: _navigateToSupport,
          ),
          ProfileMenuItem(
            icon: Icons.privacy_tip,
            title: 'Privacidade',
            onTap: _navigateToPrivacy,
          ),
          ProfileMenuItem(
            icon: Icons.settings,
            title: 'Configurações',
            onTap: _navigateToSettings,
          ),
          const SizedBox(height: 20),
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Sair',
            onTap: _showLogoutDialog,
            iconColor: Colors.red,
            textColor: Colors.red,
            showArrow: false,
          ),
        ],
      ),
    );
  }

  // Métodos de navegação e ações
  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEditProfileBottomSheet(),
    );
  }

  Widget _buildEditProfileBottomSheet() {
    final nameController = TextEditingController(text: _currentUser.name);
    final emailController = TextEditingController(text: _currentUser.email);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Editar Perfil',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  UserAvatar(
                    name: _currentUser.name,
                    profileImageUrl: _currentUser.profileImageUrl,
                    size: 100,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Salvar alterações
                      Navigator.pop(context);
                      _showSuccessSnackBar('Perfil atualizado com sucesso!');
                    },
                    child: const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPaymentMethods() {
    _showComingSoonDialog('Métodos de Pagamento');
  }

  void _navigateToTravelHistory() {
    _showComingSoonDialog('Histórico de Viagens');
  }

  void _navigateToNotifications() {
    _showComingSoonDialog('Notificações');
  }

  void _rateApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Avaliar App'),
        content:
            const Text('Você gostaria de avaliar nosso aplicativo na loja?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mais tarde'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Obrigado pela avaliação!');
            },
            child: const Text('Avaliar'),
          ),
        ],
      ),
    );
  }

  void _navigateToSupport() {
    _showComingSoonDialog('Ajuda e Suporte');
  }

  void _navigateToPrivacy() {
    _showComingSoonDialog('Privacidade');
  }

  void _navigateToSettings() {
    _showComingSoonDialog('Configurações');
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    // Implementar lógica de logout
    _showSuccessSnackBar('Você saiu da sua conta');
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginScreen()),
    //   (route) => false,
    // );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('Esta funcionalidade estará disponível em breve!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
