import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pineapp/core/services/api/api_service.dart';

class EvilWpaPage extends StatefulWidget {
  @override
  EvilWpaPageState createState() => EvilWpaPageState();
}

class EvilWpaPageState extends State<EvilWpaPage> {
  late Dio dio;
  late ApiService apiService;

  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _bssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _authController = TextEditingController();
  bool _hidden = false;
  bool _disabled = false;
  bool _captureHandshakes = false;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio, baseUrl: "http://172.16.42.1:1471");
    _loadEvilWpaSettings();
  }

  Future<void> _loadEvilWpaSettings() async {
    try {
      final response = await apiService.getEvilApSettings();
      print(response);
      setState(() {
        _ssidController.text = response['ssid'];
        _bssidController.text = response['bssid'];
        _authController.text = response['auth'];
        _passwordController.text = response['password'];
        _confirmPasswordController.text = response[
            'password']; // Par défaut, les deux champs auront la même valeur
        _hidden = response['hidden'];
        _disabled = response['disabled'];
        _captureHandshakes = response['capture_handshakes'];
      });
    } catch (e) {
      print("Erreur lors du chargement des paramètres : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),

            // SSID Field
            TextField(
              controller: _ssidController,
              decoration: InputDecoration(
                labelText: 'SSID',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // BSSID Field
            TextField(
              controller: _bssidController,
              decoration: InputDecoration(
                labelText: 'BSSID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Auth Field
            TextField(
              controller: _authController,
              decoration: InputDecoration(
                labelText: 'Authentication',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hidden Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Hidden'),
                CupertinoSwitch(
                  value: _hidden,
                  onChanged: (value) {
                    setState(() {
                      _hidden = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Disabled Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Disabled'),
                CupertinoSwitch(
                  value: _disabled,
                  onChanged: (value) {
                    setState(() {
                      _disabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Capture Handshakes Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Capture Handshakes'),
                CupertinoSwitch(
                  value: _captureHandshakes,
                  onChanged: (value) {
                    setState(() {
                      _captureHandshakes = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Save Button
            GestureDetector(
              onTap: () async {
                await _saveEvilWpaSettings();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Save Evil WPA Settings',
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 18)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEvilWpaSettings() async {
    try {
      final settingsData = {
        "ssid": _ssidController.text,
        "bssid": _bssidController.text,
        "auth": _authController.text,
        "password": _passwordController.text,
        "confirm_password": _confirmPasswordController.text,
        "hidden": _hidden,
        "disabled": _disabled,
        "capture_handshakes": _captureHandshakes,
      };

      print("Données envoyées à l'API : $settingsData");

      final response = await apiService.saveEvilApSettings(settingsData);
      print(response);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paramètres sauvegardés")),
      );
    } catch (e) {
      print("Erreur lors de la sauvegarde des paramètres : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Erreur lors de la sauvegarde des paramètres")),
      );
    }
  }
}
