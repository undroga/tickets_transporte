import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? profileImageUrl;
  final String name;
  final double size;

  const UserAvatar({
    Key? key,
    this.profileImageUrl,
    required this.name,
    this.size = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: profileImageUrl != null
          ? ClipOval(
              child: Image.network(
                profileImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildInitials();
                },
              ),
            )
          : _buildInitials(),
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        _getInitials(name),
        style: TextStyle(
          fontSize: size * 0.3,
          fontWeight: FontWeight.bold,
          color: Colors.red[600],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return 'U';
  }
}
