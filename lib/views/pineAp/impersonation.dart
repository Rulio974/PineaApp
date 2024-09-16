import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/widgets/primaryButton.dart';
import 'package:pineapp/widgets/secondaryButton.dart';

class ImpersonationPage extends StatefulWidget {
  @override
  ImpersonationPageState createState() => ImpersonationPageState();
}

class ImpersonationPageState extends State<ImpersonationPage> {
  late Dio dio;
  late ApiService apiService;

  final TextEditingController _ssidController = TextEditingController();
  List<String> ssidList = [];

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio, baseUrl: "http://172.16.42.1:1471");
  }

  Future<List<String>> _loadPineAPPool() async {
    try {
      final response = await apiService.getPineAPPool();
      final ssidsString =
          response['ssids'] as String; // Récupère la chaîne de SSIDs
      final ssidsList =
          ssidsString.split('\n'); // Divise la chaîne en une liste
      return ssidsList;
    } catch (e) {
      print("Erreur lors du chargement des SSID : $e");
      return []; // Retourne une liste vide en cas d'erreur
    }
  }

  Future<void> _addSSID() async {
    if (_ssidController.text.isNotEmpty) {
      try {
        final body = {
          "ssid": _ssidController.text,
        };
        await apiService.addSsidToPineAPPool(body);
        setState(() {
          ssidList.add(_ssidController.text);
          _ssidController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("SSID ajouté avec succès")),
        );
      } catch (e) {
        print("Erreur lors de l'ajout du SSID : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'ajout du SSID")),
        );
      }
    }
  }

  Future<void> _removeSSID(String ssid) async {
    try {
      final body = {
        "ssid": ssid,
      };
      await apiService.deleteSsidFromPineAPPool(body);
      setState(() {
        ssidList.remove(ssid);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("SSID supprimé avec succès")),
      );
    } catch (e) {
      print("Erreur lors de la suppression du SSID : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression du SSID")),
      );
    }
  }

  Future<void> _clearAllSSIDs() async {
    try {
      await apiService.deleteAllSsidFromPineAPPool();
      setState(() {
        ssidList.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tous les SSID ont été supprimés")),
      );
    } catch (e) {
      print("Erreur lors de la suppression de tous les SSID : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Erreur lors de la suppression de tous les SSID")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<String>>(
          future: _loadPineAPPool(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur lors du chargement des SSID"));
            } else {
              ssidList = snapshot.data ?? [];
              return Column(
                children: [
                  // SSID Input Field and Buttons
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              await _addSSID();
                            },
                            child: SecondaryButton(
                              text: "Add",
                              borderColor: Colors.amber,
                            )),
                      ),
                      Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              await _removeSSID(_ssidController.text);
                            },
                            child: SecondaryButton(text: "Remove")),
                      ),
                      Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              await _clearAllSSIDs();
                            },
                            child: SecondaryButton(text: "Clear")),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // SSID ListView
                  Expanded(
                    child: ListView.builder(
                      itemCount: ssidList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(ssidList[index]),
                          onTap: () {
                            _ssidController.text = ssidList[index];
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
