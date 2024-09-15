import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:pineapp/core/services/api/api_service.dart';

class PineAPSettingsPage extends StatefulWidget {
  @override
  _PineAPSettingsPageState createState() => _PineAPSettingsPageState();
}

class _PineAPSettingsPageState extends State<PineAPSettingsPage> {
  late Dio dio;
  late ApiService apiService;

  // Variables pour les paramètres
  bool logPineAPEvents = false;
  bool captureSSIDsToPool = false;
  bool clientConnectNotifications = false;
  bool clientDisconnectNotifications = false;
  bool advertiseAPImpersonationPool = false;
  String targetMacAddress = 'FF:FF:FF:FF:FF:FF';
  String sourceMacAddress = '00:11:22:33:44:55';
  String mode =
      "active"; // Mettre en minuscules pour correspondre aux valeurs du DropdownButton
  String broadcastPoolInterval = 'Normal';
  bool randomizeSourceMAC = false;
  late Future<void> _loadSettingsFuture;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio, baseUrl: "http://172.16.42.1:1471");
    _loadSettingsFuture = _loadPineAPSettings();
  }

  Future<void> _loadPineAPSettings() async {
    try {
      final response = await apiService.getPineAPSettings();
      print(response);
      setState(() {
        logPineAPEvents = response['settings']['logging'];
        captureSSIDsToPool = response['settings']['capture_ssids'] ?? false;
        clientConnectNotifications =
            response['settings']['connect_notifications'] ?? false;
        clientDisconnectNotifications =
            response['settings']['disconnect_notifications'] ?? false;
        advertiseAPImpersonationPool =
            response['settings']['broadcast_ssid_pool'] ?? false;
        targetMacAddress =
            response['settings']['target_mac'] ?? "FF:FF:FF:FF:FF:FF";
        sourceMacAddress =
            response['settings']['pineap_mac'] ?? "00:11:22:33:44:55";
        mode = response['mode']?.toLowerCase() ??
            "active"; // Assurez-vous que mode est en minuscules
      });
    } catch (e) {
      print("Erreur lors du chargement des paramètres : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier PineAP Settings'),
      ),
      body: FutureBuilder<void>(
        future: _loadSettingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erreur lors du chargement des paramètres'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  DropdownButton<String>(
                    value: mode.toLowerCase(),
                    onChanged: (String? newValue) {
                      setState(() {
                        mode = newValue!;
                      });
                    },
                    items: <String>['passive', 'active', 'advanced']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  if (mode == 'passive' || mode == 'active') ...[
                    const SizedBox(height: 20),
                    Text(
                      mode == 'passive'
                          ? 'In Passive Mode, the following PineAP features are enabled:\n\n• SSID Pool Collection\n• Event Logging'
                          : 'In Active Mode, the following PineAP features are enabled:\n\n• SSID Pool Collection\n• Event Logging\n• SSID Pool Broadcasting',
                      style: TextStyle(fontSize: 16),
                    ),
                  ] else if (mode == 'advanced') ...[
                    const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await _savePineAPSettings();
                    },
                    child: Text('Sauvegarder'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

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

  Future<void> _savePineAPSettings() async {
    try {
      final settingsData = {
        "mode": mode,
        "settings": {
          "enablePineAP": true,
          "autostartPineAP": true,
          "armedPineAP": false,
          "ap_channel": "6",
          "karma": true,
          "logging": logPineAPEvents,
          "connect_notifications": clientConnectNotifications,
          "disconnect_notifications": clientDisconnectNotifications,
          "capture_ssids": captureSSIDsToPool,
          "beacon_responses": true,
          "broadcast_ssid_pool": advertiseAPImpersonationPool,
          "broadcast_ssid_pool_random": false,
          "pineap_mac": sourceMacAddress,
          "target_mac": targetMacAddress,
          "beacon_response_interval": "NORMAL",
          "beacon_interval": "NORMAL"
        }
      };

      print("Données envoyées à l'API : $settingsData");

      await apiService.savePineAPSettings(settingsData);
      Navigator.pop(context, true);
    } catch (e) {
      print("Erreur lors de la sauvegarde des paramètres : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la sauvegarde des paramètres")),
      );
    }
  }
}
