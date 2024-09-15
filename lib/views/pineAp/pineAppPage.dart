import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/views/pineAp/pineAPSettings.dart';

class PineAPPage extends StatefulWidget {
  @override
  _PineAPPageState createState() => _PineAPPageState();
}

class _PineAPPageState extends State<PineAPPage> {
  // Variables pour stocker l'état des paramètres sélectionnés
  String pineAPMode = "Active";
  bool impersonateAllNetworks = false;
  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f6),
      body: Padding(
        padding: const EdgeInsets.only(top: 16), // Pas de padding sur la gauche
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appliquer le padding ici
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
            // ListView horizontale pour les statistiques sans padding
            SizedBox(
              height: 120, // Hauteur de la ListView
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
            // Appliquer le padding ici
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
            // Appliquer le padding ici
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
                          '$pineAPMode Mode',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: SizedBox()),
                        if (pineAPMode == "Advanced")
                          const HeroIcon(
                            HeroIcons.adjustmentsVertical,
                            color: Colors.green,
                          ),
                        if (pineAPMode == "Active")
                          const HeroIcon(
                            HeroIcons.bolt,
                            color: Colors.lime,
                          ),
                        if (pineAPMode == "Passive")
                          const HeroIcon(
                            HeroIcons.boltSlash,
                            color: Colors.blueGrey,
                          ),
                      ]),
                      const SizedBox(height: 10),
                      Text(
                          'Impersonate All Networks: ${impersonateAllNetworks ? "Enabled" : "Disabled"}'),
                      const SizedBox(height: 5),
                      Text('Options: ${selectedOptions.join(", ")}'),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Naviguer vers la page des paramètres et récupérer les valeurs
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PineAPSettingsPage(
                                  mode: pineAPMode,
                                  impersonate: impersonateAllNetworks,
                                  options: selectedOptions,
                                ),
                              ),
                            );

                            // Mettre à jour l'état avec les valeurs récupérées
                            if (result != null) {
                              setState(() {
                                pineAPMode = result['mode'];
                                impersonateAllNetworks = result['impersonate'];
                                selectedOptions = result['options'];
                              });
                            }
                          },
                          child: const Text('Modifier'),
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
