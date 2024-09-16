import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pineapp/views/auth/login.dart';
import 'package:pineapp/views/error/pineappleNotFound.dart';

class NetworkUtils {
  static Future<bool> isConnectedToPineapple(BuildContext context) async {
    // Vérification si l'appareil est connecté à un réseau WiFi
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      // Si connecté en WiFi, vérifier l'accès au Pineapple
      return await checkPineappleAccess(context);
    } else {
      // Pas connecté en WiFi, retour d'une erreur
      print("L'appareil n'est pas connecté à un réseau WiFi.");
      return false;
    }
  }

  // Vérifier l'accès au WiFi Pineapple
  static Future<bool> checkPineappleAccess(BuildContext context) async {
    try {
      final response =
          await Dio().get('http://172.16.42.1:1471/api/system/status');
      return response.statusCode == 200;
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorPage(
            onRetry: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ),
          ),
        ),
      );
      print("Erreur d'accès au WiFi Pineapple : $e");
      return false;
    }
  }
}
