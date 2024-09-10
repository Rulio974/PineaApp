import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final Function onRetry;

  ErrorPage({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erreur de Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pineapple non trouvé',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Vérifiez que vous êtes connecté au bon réseau et que l\'IP du Pineapple est correcte.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onRetry(); // Appelle la fonction pour réessayer la connexion
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
