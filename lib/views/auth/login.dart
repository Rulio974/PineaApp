import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/core/utils/secure_token.dart';
import 'package:logger/logger.dart';
import 'package:pineapp/views/dashboard/dashboard.dart';
import 'package:pineapp/views/home.dart'; // Importer la page Dashboard
import 'package:url_launcher/url_launcher.dart'; // Pour ouvrir un lien dans le navigateur

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late ApiService _apiService;
  String _loginStatus = '';
  final Logger _logger = Logger(); // Instancie le logger
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });

    final dio = Dio(); // Crée une instance de Dio
    _apiService = ApiService(dio,
        baseUrl: 'http://172.16.42.1:1471'); // Initialise ApiService avec Dio
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5), // Durée de la snackbar
      ),
    );
  }

  Future<void> _login() async {
    // Vérification des champs
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Both username and password are required.');
      return;
    }

    try {
      final response = await _apiService.login({
        'username': _usernameController.text,
        'password': _passwordController.text,
      });

      // Supposons que le token soit dans response['token']
      final token = response['token'];
      await saveToken(token); // Appelle la fonction pour sauvegarder le token

      // Ajoute un log pour l'authentification réussie
      _logger.i('Utilisateur authentifié : ${_usernameController.text}');

      setState(() {
        _loginStatus = 'Login successful';
      });

      // Redirige vers le Dashboard après une connexion réussie
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      _showErrorSnackBar('Login failed: $e');
      _logger.e('Erreur de login : $e'); // Log de l'erreur
    }
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Utilise l'application externe
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Image.asset(
                    "assets/logo.png",
                    height: 200,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center, // Centre le texte
                    text: const TextSpan(
                      text: 'Welcome to\n', // Texte sur la première ligne
                      style: TextStyle(
                        color: Colors.black, // Couleur par défaut pour le texte
                        fontSize: 24.0, // Taille de la police
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Pine', // Partie "Pine" en jaune
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 238, 226, 9), // Jaune personnalisé
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        TextSpan(
                          text: 'App', // Partie "app" en noir
                          style: TextStyle(
                              color: Colors.black, // Couleur noire
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: Colors.grey[700],
                    ),
                    suffixIcon: HeroIcon(
                      HeroIcons.user,
                      color: _usernameFocusNode.hasFocus
                          ? const Color(
                              0xfffef200) // Couleur jaune personnalisée
                          : Colors.grey, // Changement de couleur
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: const Color(
                            0xfffef200), // Couleur jaune personnalisée
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.grey[700],
                    ),
                    suffixIcon: HeroIcon(
                      HeroIcons.lockClosed,
                      color: _passwordFocusNode.hasFocus
                          ? const Color(
                              0xfffef200) // Couleur jaune personnalisée
                          : Colors.grey, // Changement de couleur
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: const Color(
                            0xfffef200), // Couleur jaune personnalisée
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: _login,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors
                              .black), // Change la couleur du texte en noir
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                          150, 50), // Réduit la largeur et augmente la hauteur
                      backgroundColor: Colors.white, // Arrière-plan blanc
                      side: const BorderSide(
                        color: Colors.black, // Bordure noire
                        width: 2.0, // Épaisseur de la bordure
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(24.0), // Change le radius ici
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(_loginStatus),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () => _launchURL(
                      'https://github.com/Rulio974'), // Remplace ton_pseudo par ton pseudo GitHub
                  child: Center(
                    child: Text(
                      'Follow me on GitHub',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
