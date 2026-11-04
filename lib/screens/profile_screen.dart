
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final Future<void> Function()? onLogout;

  const ProfileScreen({
    super.key,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> handleLogout() async {
      if (onLogout != null) {
        await onLogout!();
      } else {
        await AuthService().logout();

        if (!context.mounted) return;

        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        shadowColor: Colors.black,
        elevation: 10,
        title: const Text('Profil de l\'Utilisateur'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: handleLogout,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Informations du profil
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Nom'),
                          subtitle: Text('$firstName $lastName'),
                        ),

                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text('Email'),
                          subtitle: Text(email),
                        ),

                        ListTile(
                          leading: const Icon(Icons.security),
                          title: const Text('Rôle'),
                          subtitle: Text(role),
                        ),

                        const SizedBox(height: 24),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Colors.white60,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: handleLogout,
                          child: const Text('Se déconnecter'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
