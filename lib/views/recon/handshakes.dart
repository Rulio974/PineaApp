import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pineapp/core/services/api/api_service.dart';

class HandshakesPage extends StatefulWidget {
  @override
  _HandshakesPageState createState() => _HandshakesPageState();
}

class _HandshakesPageState extends State<HandshakesPage> {
  late Future<List<dynamic>> _futureHandshakes;

  @override
  void initState() {
    super.initState();
    _futureHandshakes = fetchWPAHandshakes();
  }

  // Fonction pour récupérer les handshakes depuis l'API
  Future<List<dynamic>> fetchWPAHandshakes() async {
    try {
      final dio = Dio();
      // Ajout de l'en-tête Authorization avec le token Bearer

      final apiService = ApiService(dio, baseUrl: "http://172.16.42.1:1471");
      final response = await apiService.getWPAHandshakes();

      // Retourne la liste des handshakes
      return response["handshakes"];
    } catch (e) {
      print("Erreur lors de la récupération des handshakes : $e");
      throw Exception("Erreur lors de la récupération des handshakes");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Handshakes Capturés'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureHandshakes,
        builder: (context, snapshot) {
          // Pendant que les données se chargent
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Si une erreur s'est produite
          else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          // Quand les données sont prêtes
          else if (snapshot.hasData) {
            final handshakes = snapshot.data!;

            if (handshakes.isEmpty) {
              return Center(child: Text('Aucun handshake capturé.'));
            }

            // Afficher la liste des handshakes capturés
            return ListView.builder(
              itemCount: handshakes.length,
              itemBuilder: (context, index) {
                final handshake = handshakes[index];
                return ListTile(
                  leading: Icon(Icons.wifi),
                  title: Text('Handshake ${index + 1}'),
                  subtitle: Text(
                      'MAC: ${handshake["mac"]}\nClient: ${handshake["client"]}\nType: ${handshake["type"]}\nTimestamp: ${handshake["timestamp"]}'),
                );
              },
            );
          }
          // Cas par défaut, au cas où snapshot.data serait null
          return Center(child: Text('Aucun résultat trouvé.'));
        },
      ),
    );
  }
}
