import 'package:flutter/material.dart';
import 'package:pineapp/views/recon/scan.dart';

class ReconPage extends StatefulWidget {
  final int page;

  ReconPage({required Key key, required this.page}) : super(key: key);

  @override
  ReconPageState createState() => ReconPageState();
}

class ReconPageState extends State<ReconPage> {
  int currentPageIndex = 0; // Index de la page actuelle

  @override
  void initState() {
    super.initState();
    currentPageIndex =
        widget.page; // Initialise l'index avec la valeur de widget.page
  }

  // Fonction appelée pour changer la page dynamiquement
  void changePage(int newIndex) {
    setState(() {
      currentPageIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(currentPageIndex), // Affiche la page correcte
    );
  }

  // Fonction pour retourner le bon contenu en fonction de l'index
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return ScanPage(); // Page de scan
      case 1:
        return Scaffold(
            body: Center(child: Text("Handshake Page"))); // Page de handshake
      default:
        return Scaffold(
            body: Center(
                child: Text("Error"))); // Page par défaut en cas d'erreur
    }
  }
}
