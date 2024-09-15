import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/widgets/recon/handshakeCard.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

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

  Future<void> _showDeleteConfirmationDialog(
      Map<String, dynamic> handshake) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          true, // Fermer la boîte de dialogue en cliquant à l'extérieur
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Voulez-vous vraiment supprimer ce handshake ?'),
                SizedBox(height: 10),
                Text('Détails du Handshake:'),
                Text('MAC Address: ${handshake["mac"]}'),
                Text('Client: ${handshake["client"]}'),
                Text('Type: ${handshake["type"]}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () async {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                await _deleteHandshake(handshake["type"],
                    handshake["mac"]); // Supprimer le handshake
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteHandshake(String type, String bssid) async {
    try {
      final dio = Dio();
      final apiService = ApiService(dio, baseUrl: "http://172.16.42.1:1471");

      // Appeler l'API pour supprimer le handshake
      final response = await apiService.deleteWPAHandshake({
        "type": type,
        "bssid": bssid,
      });

      // Vérifier la réponse de l'API
      if (response["success"] == true) {
        print("Handshake supprimé avec succès");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Handshake supprimé avec succès")),
        );

        // Rafraîchir la liste des handshakes
        setState(() {
          _futureHandshakes = fetchWPAHandshakes();
        });
      } else {
        throw Exception("Échec de la suppression du handshake");
      }
    } catch (e) {
      print("Erreur lors de la suppression du handshake : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression du handshake")),
      );
    }
  }

  Future<void> _downloadHandshake(String location) async {
    try {
      // Appel de l'API pour télécharger le fichier
      final dio = Dio();
      final apiService = ApiService(dio, baseUrl: "http://172.16.42.1:1471");

      // Extraire uniquement le nom du fichier depuis le chemin complet
      final filename = location.split('/').last;
      print("FILENAME: $filename");

      // Télécharger le fichier
      final fileData = await apiService.downloadFile({"filename": location});

      // Récupérer le répertoire de stockage temporaire
      final directory = await getTemporaryDirectory();
      // Utiliser uniquement le nom du fichier pour le chemin
      final filePath = '${directory.path}/$filename';
      print("File path: $filePath");

      // Écrire le fichier sur le stockage local
      final file = File(filePath);
      await file.writeAsBytes(fileData);

      // Ouvrir le modal de partage/téléchargement propre à l'OS
      Share.shareFiles([file.path],
          text: 'Télécharger le handshake: $filename');
    } catch (e) {
      print("Erreur lors du téléchargement du fichier : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du téléchargement du fichier")),
      );
    }
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
                          '${handshakes[0]["mac"] ?? "unknown_mac"}_${handshakes[0]["client"] ?? "unknown_client"}_${handshakes[0]["timestamp"] ?? "unknown_timestamp"}'),
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
                          // Afficher la boîte de dialogue de confirmation
                          await _showDeleteConfirmationDialog(handshakes[0]);
                          return false; // Ne pas supprimer immédiatement
                        } else if (direction == DismissDirection.endToStart) {
                          await _downloadHandshake(handshakes[0]
                              ["location"]); // Utiliser le chemin du fichier
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
                                    '${handshake["mac"] ?? "unknown_mac"}_${handshake["client"] ?? "unknown_client"}_${handshake["timestamp"] ?? "unknown_timestamp"}'),
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
                                    // Afficher la boîte de dialogue de confirmation
                                    await _showDeleteConfirmationDialog(
                                        handshake);
                                    return false; // Ne pas supprimer immédiatement
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    await _downloadHandshake(handshake[
                                        "location"]); // Utiliser le chemin du fichier
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
