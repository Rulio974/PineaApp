import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pineapp/views/auth/login.dart';
import 'package:pineapp/views/error/pineappleNotFound.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _pineappleAvailable;

  @override
  void initState() {
    super.initState();
    _pineappleAvailable = _checkPineappleAvailability();
  }

  Future<bool> _checkPineappleAvailability() async {
    final dio = Dio();
    dio.options.connectTimeout = Duration(seconds: 5); // Timeout de 5 secondes
    dio.options.receiveTimeout =
        Duration(seconds: 5); // Timeout de réception de 5 secondes

    try {
      final response = await dio
          .get('http://172.16.42.1:1471'); // L'adresse IP de base du Pineapple
      if (response.statusCode == 200) {
        return true; // Le Pineapple est disponible
      } else {
        return false; // Le Pineapple n'est pas disponible
      }
    } catch (e) {
      print('Erreur lors de la vérification du Pineapple: $e');
      return false; // En cas d'erreur, considère que le Pineapple n'est pas disponible
    }
  }

  void _retryConnection() {
    setState(() {
      _pineappleAvailable =
          _checkPineappleAvailability(); // Relance la vérification
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pineapple Login Demo',
      theme: ThemeData(
        fontFamily: 'SFProDisplay', // Police configurée

        primaryColor: Colors.white, // Couleur principale en blanc
        scaffoldBackgroundColor:
            Colors.white, // Fond blanc pour toutes les pages
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // AppBar en blanc
          iconTheme: IconThemeData(color: Colors.black), // Icônes en noir
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.white, // Couleur secondaire en blanc
        ),
      ),
      home: FutureBuilder(
        future: _pineappleAvailable,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ), // Affiche un chargement pendant la vérification
            );
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data == false) {
            return ErrorPage(
              onRetry: _retryConnection,
            ); // Redirige vers la page d'erreur si le Pineapple n'est pas trouvé
          } else {
            return LoginPage(); // Redirige vers la page de login si le Pineapple est disponible
          }
        },
      ),
    );
  }
}
