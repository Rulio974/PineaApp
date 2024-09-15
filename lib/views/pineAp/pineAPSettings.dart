import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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

  // Options spécifiques pour le mode Advanced
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

    // Initialiser les options en fonction des valeurs existantes
    logPineAPEvents = options.contains("Log PineAP Events");
    captureSSIDsToPool = options.contains("Capture SSIDs to Pool");
    clientConnectNotifications =
        options.contains("Client Connect Notifications");
    clientDisconnectNotifications =
        options.contains("Client Disconnect Notifications");
    advertiseAPImpersonationPool =
        options.contains("Advertise AP Impersonation Pool");
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
            if (mode == 'Passive' || mode == 'Active') ...[
              // Texte descriptif pour Passive et Active
              const SizedBox(height: 20),
              Text(
                mode == 'Passive'
                    ? 'In Passive Mode, the following PineAP features are enabled:\n\n• SSID Pool Collection\n• Event Logging'
                    : 'In Active Mode, the following PineAP features are enabled:\n\n• SSID Pool Collection\n• Event Logging\n• SSID Pool Broadcasting',
                style: TextStyle(fontSize: 16),
              ),
            ] else if (mode == 'Advanced') ...[
              // Options spécifiques pour Advanced
              const SizedBox(height: 20),
              _buildCupertinoSwitch(
                'Log PineAP Events',
                logPineAPEvents,
                (bool value) {
                  setState(() {
                    logPineAPEvents = value;
                    _updateOptionsList('Log PineAP Events', value);
                  });
                },
              ),
              _buildCupertinoSwitch(
                'Capture SSIDs To Pool',
                captureSSIDsToPool,
                (bool value) {
                  setState(() {
                    captureSSIDsToPool = value;
                    _updateOptionsList('Capture SSIDs to Pool', value);
                  });
                },
              ),
              _buildCupertinoSwitch(
                'Advertise AP Impersonation Pool',
                advertiseAPImpersonationPool,
                (bool value) {
                  setState(() {
                    advertiseAPImpersonationPool = value;
                    _updateOptionsList(
                        'Advertise AP Impersonation Pool', value);
                  });
                },
              ),
              _buildCupertinoSwitch(
                'Client Connect Notifications',
                clientConnectNotifications,
                (bool value) {
                  setState(() {
                    clientConnectNotifications = value;
                    _updateOptionsList('Client Connect Notifications', value);
                  });
                },
              ),
              _buildCupertinoSwitch(
                'Client Disconnect Notifications',
                clientDisconnectNotifications,
                (bool value) {
                  setState(() {
                    clientDisconnectNotifications = value;
                    _updateOptionsList(
                        'Client Disconnect Notifications', value);
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
                decoration: InputDecoration(labelText: 'Target MAC Address'),
                onChanged: (value) {
                  targetMacAddress = value;
                },
              ),
              TextFormField(
                initialValue: sourceMacAddress,
                decoration: InputDecoration(labelText: 'Source MAC Address'),
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
            const SizedBox(height: 20),
            // Bouton Sauvegarder
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'mode': mode,
                  'impersonate': impersonate,
                  'options': options,
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

  // Fonction pour mettre à jour la liste des options en fonction des sélections
  void _updateOptionsList(String option, bool isSelected) {
    if (isSelected) {
      if (!options.contains(option)) {
        options.add(option);
      }
    } else {
      options.remove(option);
    }
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
