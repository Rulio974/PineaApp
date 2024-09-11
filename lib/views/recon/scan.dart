import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/models/recon/recon_scan.dart';
import 'package:pineapp/views/recon/scanSettings.dart';
import 'package:pineapp/widgets/recon/parameterPill.dart';
import 'package:pineapp/core/utils/secure_token.dart';
import '../../core/helpers/getLastScanId_helper.dart';

class ScanPage extends StatefulWidget {
  ScanPage({super.key});
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isAlwaysCapturingHandshakes = false;
  Map<int, bool> isCapturingHandshakePerSSID = {};
  late ApiService _apiService;
  bool isScanning = false;
  int handshakesCaptured = 0;
  String scanDuration = '10 Seconds';
  List<APResults> wifiList = [];
  List<APResults> filteredWifiList = [];
  String selectedFilter = 'All';
  String _dots = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _apiService = ApiService(dio, baseUrl: 'http://172.16.42.1:1471');
    fetchLastScanResults();
  }

  Future<void> fetchLastScanResults() async {
    int lastScanId = await getLastScanId(_apiService);
    if (lastScanId != -1) {
      try {
        final response = await Dio().get(
            'http://172.16.42.1:1471/api/recon/scans/$lastScanId',
            options:
                Options(headers: {"Authorization": "${await getToken()}"}));

        final List<dynamic> apResultsJson = response.data['APResults'];

        setState(() {
          wifiList = apResultsJson
              .map((item) => APResults.fromJson(item as Map<String, dynamic>))
              .toList();
          filteredWifiList = wifiList;
        });
        print('Liste des WiFi récupérés: $wifiList');
      } catch (e) {
        print('Erreur lors de la récupération des résultats du scan : $e');
      }
    } else {
      print('Aucun scan trouvé.');
    }
  }

  Future<void> captureHandshakesForAll() async {
    for (var wifi in wifiList) {
      try {
        await _apiService
            .startWPAHandshake({"bssid": wifi.bssid, "channel": wifi.channel});
        print('Capture WPA Handshake démarrée pour ${wifi.bssid}');
      } catch (e) {
        print('Erreur lors de la capture WPA pour ${wifi.bssid} : $e');
      }
    }
    print('Capture WPA Handshakes pour tous les WiFi terminée.');
  }

  Future<void> stopHandshakesForAll() async {
    for (var wifi in wifiList) {
      try {
        await _apiService.stopWPAHandshake();
        print('Capture WPA Handshake arrêtée pour ${wifi.bssid}');
      } catch (e) {
        print(
            'Erreur lors de l\'arrêt de la capture WPA pour ${wifi.bssid} : $e');
      }
    }
    print('Capture WPA Handshakes stoppée pour tous les WiFi.');
  }

  Future<void> toggleCaptureHandshakesForAll() async {
    if (!isAlwaysCapturingHandshakes) {
      await captureHandshakesForAll();
      setState(() {
        isAlwaysCapturingHandshakes = true;
        for (var wifi in wifiList) {
          isCapturingHandshakePerSSID[wifi.hashCode] = true;
        }
      });
    } else {
      await stopHandshakesForAll();
      setState(() {
        isAlwaysCapturingHandshakes = false;
        for (var wifi in wifiList) {
          isCapturingHandshakePerSSID[wifi.hashCode] = false;
        }
      });
    }
  }

  Future<void> toggleCaptureHandshakeForSSID(APResults wifi) async {
    final isCapturing = isCapturingHandshakePerSSID[wifi.hashCode] ?? false;
    if (isCapturing) {
      await stopHandshakeCaptureForSSID(wifi);
      setState(() {
        isCapturingHandshakePerSSID[wifi.hashCode] = false;
      });
    } else {
      await startHandshakeCaptureForSSID(wifi);
      setState(() {
        isCapturingHandshakePerSSID[wifi.hashCode] = true;
      });
    }
  }

  Future<void> startHandshakeCaptureForSSID(APResults wifi) async {
    try {
      await _apiService.startWPAHandshake({
        "bssid": wifi.bssid,
        "channel": wifi.channel,
      });
      print("Capture WPA Handshake démarrée pour ${wifi.bssid}");
    } catch (e) {
      print("Erreur lors de la capture WPA pour ${wifi.bssid} : $e");
    }
  }

  Future<void> stopHandshakeCaptureForSSID(APResults wifi) async {
    try {
      await _apiService.stopWPAHandshake();
      print("Capture WPA Handshake arrêtée pour ${wifi.bssid}");
    } catch (e) {
      print("Erreur lors de l'arrêt de la capture WPA pour ${wifi.bssid} : $e");
    }
  }

  // Fonction pour démarrer un nouveau scan
  void startScan() async {
    setState(() {
      isScanning = true;
    });

    int scanDurationInSeconds = _getDurationInSeconds(scanDuration);

    try {
      await _apiService.startRecon({'scanDuration': scanDurationInSeconds});

      Future.delayed(Duration(seconds: scanDurationInSeconds), () async {
        fetchLastScanResults();
        setState(() {
          isScanning = false;
        });
      });
    } catch (e) {
      setState(() {
        isScanning = false;
      });
      print('Erreur de scan : $e');
    }
  }

  int _getDurationInSeconds(String duration) {
    switch (duration) {
      case '10 Seconds':
        return 10;
      case '1 Minute':
        return 60;
      case '5 Minutes':
        return 300;
      case '10 Minutes':
        return 600;
      default:
        return 60;
    }
  }

  // Fonction pour naviguer vers la page des paramètres et récupérer les choix
  Future<void> navigateToSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanSettingsPage(
          initialDuration: scanDuration,
          initialCaptureHandshakes: isAlwaysCapturingHandshakes,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        scanDuration = result['duration'];
        isAlwaysCapturingHandshakes = result['alwaysCaptureHandshakes'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f6),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Scan settings",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: navigateToSettings,
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: HeroIcon(
                        HeroIcons.cog6Tooth,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Parameterpill(
                    height: 30,
                    title: scanDuration,
                    icon: HeroIcons.clock,
                    color: Colors.lightBlue,
                  ),
                  Parameterpill(
                    title: isAlwaysCapturingHandshakes
                        ? 'Always capture handshake'
                        : 'No always capture handshake',
                    icon: HeroIcons.handRaised,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: isScanning ? null : startScan,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  gradient: isScanning
                      ? const LinearGradient(
                          colors: [Colors.redAccent, Colors.red],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [Colors.blueAccent, Colors.blueGrey],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeroIcon(
                        isScanning ? HeroIcons.arrowPath : HeroIcons.wifi,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        isScanning ? 'Scanning...' : 'Start Scan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Results",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap:
                    true, // Permet à la GridView de s'ajuster à son contenu
                physics:
                    const NeverScrollableScrollPhysics(), // Désactive le scroll interne de la GridView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: filteredWifiList.length,
                itemBuilder: (context, index) {
                  final wifi = filteredWifiList[index];
                  return GestureDetector(
                    onTap: () => _showWifiModal(wifi),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SSID: ${wifi.ssid?.isNotEmpty == true ? wifi.ssid : "hidden"}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Channel: ${wifi.channel}'),
                          Text('Clients: ${wifi.clients?.length ?? 0}'),
                          Text('Signal: ${wifi.signal}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Affichage du modal avec des actions pour un WiFi spécifique
  void _showWifiModal(APResults wifi) {
    bool isDeauthenticating = false;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                    'SSID: ${wifi.ssid?.isNotEmpty == true ? wifi.ssid : "Hidden"}'),
                subtitle: Text('MAC: ${wifi.bssid}'),
              ),
              ListTile(
                title: Text('Channel: ${wifi.channel}'),
              ),
              ListTile(
                title: Text('Security: ${wifi.encryption}'),
              ),
              Wrap(
                spacing: 10.0, // Espace entre les boutons horizontalement
                runSpacing: 10.0, // Espace entre les boutons verticalement
                children: [
                  ElevatedButton(
                    onPressed: wifi.ssid == null
                        ? null // Désactiver le bouton si le SSID est nul
                        : () async {
                            try {
                              // Appeler l'API pour ajouter le SSID au filtre
                              final response =
                                  await _apiService.addSsidToFilter({
                                'ssid': wifi
                                    .ssid, // Assure-toi que le SSID est correct
                              });

                              if (response['success'] == true) {
                                // Afficher un message de succès
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'SSID ajouté avec succès au filtre')),
                                );
                              } else {
                                // Gérer les erreurs si le succès est false
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Erreur lors de l\'ajout du SSID au filtre')),
                                );
                              }
                            } catch (e) {
                              // Gérer les exceptions ou erreurs réseau
                              print('Erreur : $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Erreur de connexion ou autre : $e')),
                              );
                            }
                          },
                    child: const Text('Add SSID to Filter'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Vérifie que des clients existent pour cet AP
                        if (wifi.clients != null && wifi.clients!.isNotEmpty) {
                          // Boucler sur tous les clients et les ajouter au filtre
                          for (var client in wifi.clients!) {
                            final response =
                                await _apiService.addClientToFilter({
                              'mac': client
                                  .client_mac, // Le MAC du client à ajouter
                            });

                            if (response['success'] != true) {
                              // Si une erreur survient lors de l'ajout d'un client, afficher un message d'erreur
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Erreur lors de l\'ajout du client ${client.client_mac}')),
                              );
                              return;
                            }
                          }

                          // Afficher un message de succès après avoir ajouté tous les clients
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Tous les clients ont été ajoutés avec succès au filtre')),
                          );
                        } else {
                          // Afficher un message si aucun client n'est trouvé
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Aucun client à ajouter au filtre')),
                          );
                        }
                      } catch (e) {
                        // Gérer les exceptions ou erreurs réseau
                        print('Erreur : $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Erreur de connexion ou autre erreur : $e')),
                        );
                      }
                    },
                    child: const Text('Add All Clients to Filter'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Vérifie que des clients existent pour cet AP
                        if (wifi.clients != null && wifi.clients!.isNotEmpty) {
                          // Boucler sur tous les clients et les ajouter au filtre
                          for (var client in wifi.clients!) {
                            final response =
                                await _apiService.addClientToFilter({
                              'mac': client
                                  .client_mac, // Le MAC du client à ajouter
                            });

                            if (response['success'] != true) {
                              // Si une erreur survient lors de l'ajout d'un client, afficher un message d'erreur
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Erreur lors de l\'ajout du client ${client.client_mac}')),
                              );
                              return;
                            }
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Tous les clients ont été ajoutés avec succès au filtre')),
                          );
                        } else {
                          // Afficher un message si aucun client n'est trouvé
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Aucun client à ajouter au filtre')),
                          );
                        }
                      } catch (e) {
                        print('Erreur : $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Erreur de connexion ou autre erreur : $e')),
                        );
                      }
                    },
                    child: const Text('Add All Clients to Filter'),
                  ),
                  ElevatedButton(
                    onPressed: isDeauthenticating
                        ? null // Désactive le bouton pendant la déauthentification
                        : () async {
                            setState(() {
                              isDeauthenticating = true; // Désactive le bouton
                            });

                            try {
                              final response =
                                  await _apiService.deauthAllClients({
                                "bssid": wifi.bssid,
                                "multiplier":
                                    5, // ou tout autre nombre que tu veux
                                "channel": wifi.channel,
                                "clients": wifi.clients!
                                    .map((client) => client.client_mac)
                                    .toList(),
                              });
                              print(
                                  "Deauthenticate All Clients action: $response");
                            } catch (e) {
                              print(
                                  "Erreur lors de la déauthentification des clients : $e");
                            } finally {
                              // Attendre 2 secondes avant de réactiver le bouton
                              await Future.delayed(const Duration(seconds: 10));
                              setState(() {
                                isDeauthenticating =
                                    false; // Réactive le bouton après la réponse et le délai
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDeauthenticating ? Colors.grey : Colors.red,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    child: isDeauthenticating
                        ? const Text(
                            'Deauthenticating...') // Affiche un texte différent pendant la requête
                        : const Text('Deauthenticate All Clients'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleCaptureHandshakeForSSID(
                          wifi); // Appelle la fonction toggle
                      setState(() {});
                    },
                    child: Text(isCapturingHandshakePerSSID[wifi.hashCode] ==
                            true
                        ? 'Stop handshake'
                        : 'Capture handshake'), // Affiche "Stop handshake" si la capture est en cours
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
