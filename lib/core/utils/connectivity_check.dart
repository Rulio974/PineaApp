import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class NetworkUtils {
  static Future<bool> isConnectedToPineapple() async {
    // Vérification si l'appareil est connecté à un réseau WiFi
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      // Si connecté en WiFi, vérifier l'accès au Pineapple
      return await checkPineappleAccess();
    } else {
      // Pas connecté en WiFi, retour d'une erreur
      print("L'appareil n'est pas connecté à un réseau WiFi.");
      return false;
    }
  }

  // Vérifier l'accès au WiFi Pineapple
  static Future<bool> checkPineappleAccess() async {
    try {
      final response =
          await Dio().get('http://172.16.42.1:1471/api/system/status');
      return response.statusCode == 200;
    } catch (e) {
      print("Erreur d'accès au WiFi Pineapple : $e");
      return false;
    }
  }
}
