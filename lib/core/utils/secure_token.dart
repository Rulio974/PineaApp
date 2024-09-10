import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Initialisation de la classe FlutterSecureStorage pour gérer le stockage sécurisé
final _secureStorage = FlutterSecureStorage();

// Fonction pour sauvegarder le token de manière sécurisée
Future<void> saveToken(String token) async {
  await _secureStorage.write(key: 'auth_token', value: token);
}

// Fonction pour récupérer le token de manière sécurisée
Future<String?> getToken() async {
  return await _secureStorage.read(key: 'auth_token');
}

// Fonction pour supprimer le token de manière sécurisée (utile lors du logout)
Future<void> deleteToken() async {
  await _secureStorage.delete(key: 'auth_token');
}
