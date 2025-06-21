import 'package:flutter/material.dart';
import 'package:skillpath/services/auth_service.dart';

class UnifiedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const UnifiedAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return AppBar(
      title: Text(title),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await authService.signOut();
          },
          tooltip: 'Sign Out',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 