import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
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
          const SnackBar(content: Text("SSID ajouté avec succès")),
        );
      } catch (e) {
        print("Erreur lors de l'ajout du SSID : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'ajout du SSID")),
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
        const SnackBar(content: Text("SSID supprimé avec succès")),
      );
    } catch (e) {
      print("Erreur lors de la suppression du SSID : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la suppression du SSID")),
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
        const SnackBar(content: Text("Tous les SSID ont été supprimés")),
      );
    } catch (e) {
      print("Erreur lors de la suppression de tous les SSID : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Erreur lors de la suppression de tous les SSID")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: FutureBuilder<List<String>>(
          future: _loadPineAPPool(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text("Erreur lors du chargement des SSID"));
            } else {
              ssidList = snapshot.data ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SSID Input Field and Buttons
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        TextField(
                          controller: _ssidController,
                          decoration: InputDecoration(
                            labelText: 'SSID',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.blue),
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
                                  child: const SecondaryButton(
                                    text: "Add",
                                    margin: EdgeInsets.only(right: 8),
                                    borderColor: Colors.green,
                                    icon: HeroIcon(HeroIcons.plusCircle,
                                        size: 20),
                                  )),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await _removeSSID(_ssidController.text);
                                },
                                child: const SecondaryButton(
                                  margin: EdgeInsets.only(right: 8, left: 8),
                                  text: "Remove",
                                  borderColor: Colors.orange,
                                  icon: HeroIcon(
                                    HeroIcons.minusCircle,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    await _clearAllSSIDs();
                                  },
                                  child: const SecondaryButton(
                                    text: "Clear",
                                    margin: EdgeInsets.only(left: 8),
                                    borderColor: Colors.red,
                                    icon: HeroIcon(HeroIcons.xCircle, size: 20),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Divider(
                  //   color: Colors.black,
                  //   thickness: 1,
                  // ),

                  // SSID ListView
                  Text(
                    "SSIDs pool",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      child: ListView.builder(
                        itemCount: ssidList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(ssidList[index],
                                style: const TextStyle(fontSize: 16)),
                            onTap: () {
                              _ssidController.text = ssidList[index];
                            },
                          );
                        },
                      ),
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
