import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:dio/dio.dart';
import 'package:pineapp/views/pineAp/pineAPSettings.dart';
import 'package:pineapp/core/services/api/api_service.dart';

class PineAPPage extends StatefulWidget {
  @override
  _PineAPPageState createState() => _PineAPPageState();
}

class _PineAPPageState extends State<PineAPPage> {
  late Dio dio;
  late ApiService apiService;

  // Variables pour stocker les paramètres
  bool logPineAPEvents = false;
  bool captureSSIDsToPool = false;
  bool clientConnectNotifications = false;
  bool clientDisconnectNotifications = false;
  bool advertiseAPImpersonationPool = false;
  bool impersonateAllNetworks = false; // Pour karma
  String targetMacAddress = 'FF:FF:FF:FF:FF:FF';
  String sourceMacAddress = '00:11:22:33:44:55';
  String mode = "active"; // Mode initial

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio, baseUrl: "http://172.16.42.1:1471");
    _loadPineAPSettings(); // Charger les paramètres au démarrage
  }

  String capitalizeFirstLetter(String word) {
    if (word.isEmpty) {
      return word; // Return empty string if input is empty
    }
    return word[0].toUpperCase() + word.substring(1);
  }

  // Charger les paramètres actuels
  Future<void> _loadPineAPSettings() async {
    try {
      final response = await apiService.getPineAPSettings();
      setState(() {
        // Mise à jour des variables avec les données récupérées
        logPineAPEvents = response['settings']['logging'] ?? false;
        captureSSIDsToPool = response['settings']['capture_ssids'] ?? false;
        clientConnectNotifications =
            response['settings']['connect_notifications'] ?? false;
        clientDisconnectNotifications =
            response['settings']['disconnect_notifications'] ?? false;
        advertiseAPImpersonationPool =
            response['settings']['broadcast_ssid_pool'] ?? false;
        impersonateAllNetworks = response['settings']['karma'] ?? false;
        targetMacAddress =
            response['settings']['target_mac'] ?? 'FF:FF:FF:FF:FF:FF';
        sourceMacAddress =
            response['settings']['pineap_mac'] ?? '00:11:22:33:44:55';
        mode = response['mode']?.toLowerCase() ??
            'active'; // Assurez-vous que mode est en minuscules
      });
    } catch (e) {
      print("Erreur lors du chargement des paramètres : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f6),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Statistics", style: TextStyle(fontSize: 24)),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 16),
                    _buildInfoCard(
                      'Total SSIDs',
                      '1',
                      const HeroIcon(
                        HeroIcons.wifi,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    _buildInfoCard(
                      'Clients Connected',
                      '0',
                      const HeroIcon(
                        HeroIcons.user,
                        color: Colors.redAccent,
                      ),
                    ),
                    _buildInfoCard(
                      'Handshakes Captured',
                      '2',
                      const HeroIcon(
                        HeroIcons.cubeTransparent,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("PineAp", style: TextStyle(fontSize: 24)),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                            '${capitalizeFirstLetter(mode)} Mode', // Statique car basé sur les options
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: SizedBox()),
                          const HeroIcon(
                            HeroIcons.adjustmentsVertical,
                            color: Colors.green,
                          ),
                        ]),
                        // Afficher toutes les options pour le mode Advanced
                        if (mode == 'passive' || mode == 'active') ...[
                          const SizedBox(height: 20),
                          Text(
                            mode == 'passive'
                                ? 'In Passive Mode, the following PineAP features are enabled:\n\n• SSID Pool Collection\n• Event Logging'
                                : 'In Active Mode, the following PineAP features are enabled:\n\n• SSID Pool Collection\n• Event Logging\n• SSID Pool Broadcasting',
                            style: TextStyle(fontSize: 16),
                          ),
                        ] else if (mode == 'advanced') ...[
                          const SizedBox(height: 30),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 10.0,
                            children: [
                              _buildOptionChip(
                                'Impersonate All Networks',
                                impersonateAllNetworks,
                              ),
                              _buildOptionChip(
                                'Log PineAP Events',
                                logPineAPEvents,
                              ),
                              _buildOptionChip(
                                'Capture SSIDs to Pool',
                                captureSSIDsToPool,
                              ),
                              _buildOptionChip(
                                'Client Connect Notifications',
                                clientConnectNotifications,
                              ),
                              _buildOptionChip(
                                'Client Disconnect Notifications',
                                clientDisconnectNotifications,
                              ),
                              _buildOptionChip(
                                'Advertise AP Impersonation Pool',
                                advertiseAPImpersonationPool,
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Radius de 8
                              ),
                            ),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PineAPSettingsPage(),
                                ),
                              );

                              // Recharger les paramètres après modification
                              if (result != null) {
                                _loadPineAPSettings(); // Recharger les paramètres après retour
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.edit, color: Colors.white),
                                const SizedBox(width: 8),
                                const Text('Edit PineAP Settings'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour les options
  Widget _buildOptionChip(String label, bool isActive) {
    return Row(
      children: [
        if (isActive)
          const HeroIcon(HeroIcons.checkCircle, color: Colors.green),
        if (!isActive) const HeroIcon(HeroIcons.xCircle, color: Colors.red),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  // Widget pour les cartes de statistiques
  Widget _buildInfoCard(String title, String count, HeroIcon icon) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(width: 30),
            icon,
          ]),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
