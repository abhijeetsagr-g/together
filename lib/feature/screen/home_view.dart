import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:together/feature/service/auth_service.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key}) : _authService = AuthService();

  final AuthService _authService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Together')),
      body: StreamBuilder<User?>(
        stream: _authService.firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;

          if (snapshot.hasError) {
            return const Center(child: Text('Auth error'));
          }

          if (user == null) {
            return Center(
              child: FilledButton.icon(
                onPressed: () => _signIn(context),
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName ?? 'No name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(user.email ?? 'No email'),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => _authService.signOut(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _signIn(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final credential = await _authService.signIn();

    if (credential == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Sign-in failed or cancelled')),
      );
    }
  }
}
