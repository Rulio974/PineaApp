import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/widgets/recon/handshakeCard.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dio/dio.dart';

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

  Future<List<dynamic>> fetchWPAHandshakes() async {
    try {
      final dio = Dio();

      final apiService = ApiService(dio, baseUrl: "http://172.16.42.1:1471");
      final response = await apiService.getWPAHandshakes();

      List<dynamic> handshakes = response["handshakes"];
      print(handshakes);
      handshakes.sort((a, b) => DateTime.parse(b["timestamp"])
          .compareTo(DateTime.parse(a["timestamp"])));

      return handshakes;
    } catch (e) {
      print("Erreur lors de la récupération des handshakes : $e");
      throw Exception("Erreur lors de la récupération des handshakes");
    }
  }

  Future<void> _deleteHandshake(int id) async {
    // Logique de suppression à implémenter
    print("Supprimer le handshake avec l'id: $id");
  }

  Future<void> _downloadHandshake(int id) async {
    // Logique de téléchargement à implémenter
    print("Télécharger le handshake avec l'id: $id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f6),
      body: FutureBuilder<List<dynamic>>(
        future: _futureHandshakes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final handshakes = snapshot.data!;

            if (handshakes.isEmpty) {
              return const Center(child: Text('Aucun handshake capturé.'));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Last captured handshake",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    Dismissible(
                      key: Key(
                          '${handshakes[0]["mac"]}_${handshakes[0]["client"]}_${handshakes[0]["timestamp"]}'),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.blue,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.download, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          await _deleteHandshake(handshakes[0]["id"]);
                          return true; // Confirmer la suppression
                        } else if (direction == DismissDirection.endToStart) {
                          await _downloadHandshake(handshakes[0]["id"]);
                          return false; // Ne pas supprimer, juste télécharger
                        }
                        return false;
                      },
                      child: HandshakeCard(handshake: handshakes[0]),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Captured handshakes",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          handshakes.length - 1, // Excluding the first item
                      itemBuilder: (context, index) {
                        final handshake =
                            handshakes[index + 1]; // Start from the second item
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Dismissible(
                                key: Key(
                                    '${handshake["mac"]}_${handshake["client"]}_${handshake["timestamp"]}'),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.blue,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Icon(Icons.download,
                                      color: Colors.white),
                                ),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    await _deleteHandshake(handshake["id"]);
                                    return true; // Confirmer la suppression
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    await _downloadHandshake(handshake["id"]);
                                    return false; // Ne pas supprimer, juste télécharger
                                  }
                                  return false;
                                },
                                child: HandshakeCard(handshake: handshake),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('Aucun résultat trouvé.'));
        },
      ),
    );
  }
}
