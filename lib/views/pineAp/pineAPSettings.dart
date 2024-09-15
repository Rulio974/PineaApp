import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Importer Cupertino

class PineAPSettingsPage extends StatefulWidget {
  final String mode;
  final bool impersonate;
  final List<String> options;

  PineAPSettingsPage({
    required this.mode,
    required this.impersonate,
    required this.options,
  });

  @override
  _PineAPSettingsPageState createState() => _PineAPSettingsPageState();
}

class _PineAPSettingsPageState extends State<PineAPSettingsPage> {
  late String mode;
  late bool impersonate;
  late List<String> options;

  // Options spécifiques
  bool logPineAPEvents = false;
  bool captureSSIDsToPool = false;
  bool clientConnectNotifications = false;
  bool clientDisconnectNotifications = false;
  bool advertiseAPImpersonationPool = false;
  String broadcastPoolInterval = 'Normal';
  String targetMacAddress = 'FF:FF:FF:FF:FF:FF';
  String sourceMacAddress = '00:11:22:33:44:55';
  bool randomizeSourceMAC = false;

  @override
  void initState() {
    super.initState();
    mode = widget.mode;
    impersonate = widget.impersonate;
    options = widget.options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier PineAP Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dropdown pour le mode
            DropdownButton<String>(
              value: mode,
              onChanged: (String? newValue) {
                setState(() {
                  mode = newValue!;
                });
              },
              items: <String>['Passive', 'Active', 'Advanced']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // CupertinoSwitch pour impersonate all networks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Impersonate All Networks'),
                CupertinoSwitch(
                  value: impersonate,
                  onChanged: (bool value) {
                    setState(() {
                      impersonate = value;
                    });
                  },
                ),
              ],
            ),
            // Options spécifiques en fonction du mode
            if (mode == 'Passive' ||
                mode == 'Active' ||
                mode == 'Advanced') ...[
              if (mode != 'Passive') // Options pour Active et Advanced
                Column(
                  children: [
                    _buildCupertinoSwitch(
                      'Log PineAP Events',
                      logPineAPEvents,
                      (bool value) {
                        setState(() {
                          logPineAPEvents = value;
                        });
                      },
                    ),
                    _buildCupertinoSwitch(
                      'Capture SSIDs To Pool',
                      captureSSIDsToPool,
                      (bool value) {
                        setState(() {
                          captureSSIDsToPool = value;
                        });
                      },
                    ),
                    _buildCupertinoSwitch(
                      'Advertise AP Impersonation Pool',
                      advertiseAPImpersonationPool,
                      (bool value) {
                        setState(() {
                          advertiseAPImpersonationPool = value;
                        });
                      },
                    ),
                  ],
                ),
              if (mode == 'Advanced') // Options spécifiques à Advanced
                Column(
                  children: [
                    _buildCupertinoSwitch(
                      'Client Connect Notifications',
                      clientConnectNotifications,
                      (bool value) {
                        setState(() {
                          clientConnectNotifications = value;
                        });
                      },
                    ),
                    _buildCupertinoSwitch(
                      'Client Disconnect Notifications',
                      clientDisconnectNotifications,
                      (bool value) {
                        setState(() {
                          clientDisconnectNotifications = value;
                        });
                      },
                    ),
                    // Dropdown pour Broadcast Pool Interval
                    DropdownButton<String>(
                      value: broadcastPoolInterval,
                      onChanged: (String? newValue) {
                        setState(() {
                          broadcastPoolInterval = newValue!;
                        });
                      },
                      items: <String>['Normal', 'Low', 'High', 'Maximum']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // Champs pour les adresses MAC
                    TextFormField(
                      initialValue: targetMacAddress,
                      decoration:
                          InputDecoration(labelText: 'Target MAC Address'),
                      onChanged: (value) {
                        targetMacAddress = value;
                      },
                    ),
                    TextFormField(
                      initialValue: sourceMacAddress,
                      decoration:
                          InputDecoration(labelText: 'Source MAC Address'),
                      onChanged: (value) {
                        sourceMacAddress = value;
                      },
                    ),
                    _buildCupertinoSwitch(
                      'Randomize Source MAC',
                      randomizeSourceMAC,
                      (bool value) {
                        setState(() {
                          randomizeSourceMAC = value;
                        });
                      },
                    ),
                  ],
                ),
            ],
            // Bouton Sauvegarder
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'mode': mode,
                  'impersonate': impersonate,
                  'options': options,
                  'logPineAPEvents': logPineAPEvents,
                  'captureSSIDsToPool': captureSSIDsToPool,
                  'clientConnectNotifications': clientConnectNotifications,
                  'clientDisconnectNotifications':
                      clientDisconnectNotifications,
                  'advertiseAPImpersonationPool': advertiseAPImpersonationPool,
                  'broadcastPoolInterval': broadcastPoolInterval,
                  'targetMacAddress': targetMacAddress,
                  'sourceMacAddress': sourceMacAddress,
                  'randomizeSourceMAC': randomizeSourceMAC,
                });
              },
              child: Text('Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction utilitaire pour construire un CupertinoSwitch avec un label
  Widget _buildCupertinoSwitch(
      String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
