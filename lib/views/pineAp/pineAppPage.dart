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

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio, baseUrl: "http://172.16.42.1:1471");
  }

  // Charger les paramètres actuels
  Future<Map<String, dynamic>> _loadPineAPSettings() async {
    try {
      final response = await apiService.getPineAPSettings();
      return response;
    } catch (e) {
      print("Erreur lors du chargement des paramètres : $e");
      return {}; // En cas d'erreur, on retourne un map vide
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f6),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadPineAPSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
                child: Text('Erreur lors du chargement des paramètres.'));
          } else {
            final data = snapshot.data!;
            final impersonateAllNetworks = data['karma'] ?? false;
            final selectedOptions = _extractOptions(data);

            return SingleChildScrollView(
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
                              )),
                          _buildInfoCard(
                              'Clients Connected',
                              '0',
                              const HeroIcon(
                                HeroIcons.user,
                                color: Colors.redAccent,
                              )),
                          _buildInfoCard(
                              'Handshakes Captured',
                              '2',
                              const HeroIcon(
                                HeroIcons.cubeTransparent,
                                color: Colors.indigo,
                              )),
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
                                  'Advanced Mode', // Statique car basé sur les options
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(child: SizedBox()),
                                const HeroIcon(
                                  HeroIcons.adjustmentsVertical,
                                  color: Colors.green,
                                ),
                              ]),
                              const SizedBox(height: 30),
                              // Afficher toutes les options pour le mode Advanced
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 10.0,
                                children: [
                                  _buildOptionChip('Impersonate All Networks',
                                      impersonateAllNetworks),
                                  _buildOptionChip(
                                      'Log PineAP Events',
                                      selectedOptions
                                          .contains('Log PineAP Events')),
                                  _buildOptionChip(
                                      'Capture SSIDs to Pool',
                                      selectedOptions
                                          .contains('Capture SSIDs to Pool')),
                                  _buildOptionChip(
                                      'Client Connect Notifications',
                                      selectedOptions.contains(
                                          'Client Connect Notifications')),
                                  _buildOptionChip(
                                      'Client Disconnect Notifications',
                                      selectedOptions.contains(
                                          'Client Disconnect Notifications')),
                                  _buildOptionChip(
                                      'Advertise AP Impersonation Pool',
                                      selectedOptions.contains(
                                          'Advertise AP Impersonation Pool')),
                                ],
                              ),
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
                                      borderRadius: BorderRadius.circular(
                                          8), // Radius de 8
                                    ),
                                  ),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PineAPSettingsPage(),
                                      ),
                                    );

                                    // Recharger les paramètres après modification
                                    if (result != null) {
                                      setState(() {});
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.edit,
                                          color: Colors.white),
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
                    Container(
                      height: 400,
                      width: double.infinity,
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Extraire les options à partir de la réponse
  List<String> _extractOptions(Map<String, dynamic> settings) {
    List<String> options = [];
    if (settings['logging'] == true) options.add('Log PineAP Events');
    if (settings['capture_ssids'] == true) options.add('Capture SSIDs to Pool');
    if (settings['connect_notifications'] == true)
      options.add('Client Connect Notifications');
    if (settings['disconnect_notifications'] == true)
      options.add('Client Disconnect Notifications');
    if (settings['broadcast_ssid_pool'] == true)
      options.add('Advertise AP Impersonation Pool');
    return options;
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
