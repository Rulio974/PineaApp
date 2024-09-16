import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:country_picker/country_picker.dart';

class OpenApPage extends StatefulWidget {
  @override
  OpenApPageState createState() => OpenApPageState();
}

class OpenApPageState extends State<OpenApPage> {
  late Dio dio;
  late ApiService apiService;

  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _bssidController = TextEditingController();
  String _selectedCountry = 'IE';
  int _selectedChannel = 1;
  bool _hidden = false;
  bool _enabled = true;

  final Map<int, String> _channelFrequency = {
    1: '2.412 GHz',
    2: '2.417 GHz',
    3: '2.422 GHz',
    4: '2.427 GHz',
    5: '2.432 GHz',
    6: '2.437 GHz',
    7: '2.442 GHz',
    8: '2.447 GHz',
    9: '2.452 GHz',
    10: '2.457 GHz',
    11: '2.462 GHz',
    12: '2.467 GHz',
    13: '2.472 GHz',
    14: '2.484 GHz'
  };

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio, baseUrl: "http://172.16.42.1:1471");
    _loadOpenAPSettings();
  }

  Future<void> _loadOpenAPSettings() async {
    try {
      final response = await apiService.getOpenAPSettings();
      setState(() {
        _ssidController.text = response['ssid'];
        _bssidController.text = response['bssid'];
        _selectedCountry = response['country'];
        _selectedChannel = response['channel'];
        _hidden = response['hidden'];
        _enabled = response['enabled'];
      });
    } catch (e) {
      print("Erreur lors du chargement des paramètres : $e");
    }
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false, // affiche uniquement les noms de pays
      showSearch: true,
      useSafeArea: true,
      searchAutofocus: true,

      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country.countryCode;
        });
      },
    );
  }

  void _openChannelPicker() {
    print(
        "Channels available: ${_channelFrequency.keys.toList()}"); // Debugging line
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: _channelFrequency.keys.map((channel) {
            return ListTile(
              // leading: HeroIcon(HeroIcons.checkCircle, color: Colors.green),
              title: Text('Channel $channel (${_channelFrequency[channel]})'),
              onTap: () {
                setState(() {
                  _selectedChannel = channel;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // SSID Field
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: _ssidController,
              decoration: InputDecoration(
                labelText: 'SSID',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color:
                          Colors.black), // Bordure bleue quand non sélectionné
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.blue), // Bordure jaune quand sélectionné
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
                  borderSide: BorderSide(
                      color:
                          Colors.black), // Bordure bleue quand non sélectionné
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.blue), // Bordure jaune quand sélectionné
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Country Selector
            GestureDetector(
              onTap: _openCountryPicker,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blueGrey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Select Country (${_selectedCountry})",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 10,
                    ),
                    const HeroIcon(HeroIcons.globeEuropeAfrica)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: _openChannelPicker,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blueGrey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Select Channel (${_selectedChannel} - ${_channelFrequency[_selectedChannel]})',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 10,
                    ),
                    const HeroIcon(HeroIcons.wifi)
                  ],
                ),
              ),
            ),

            // Channel Selector

            const SizedBox(height: 30),

            // Hidden Switch
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
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
            ),
            const SizedBox(height: 16),

            // Enabled Switch
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enabled'),
                  CupertinoSwitch(
                    value: _enabled,
                    onChanged: (value) {
                      setState(() {
                        _enabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                await _saveOpenAPSettings();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(8),
                  // border: Border.all(color: Colors.blueGrey)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Save Open AP settings',
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

  Future<void> _saveOpenAPSettings() async {
    try {
      final settingsData = {
        "ssid": _ssidController.text,
        "bssid": _bssidController.text,
        "country": _selectedCountry,
        "channel": _selectedChannel,
        "hidden": _hidden,
        "enabled": _enabled,
      };

      print("Données envoyées à l'API : $settingsData");

      final response = await apiService.saveOpenAPSettings(settingsData);
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
