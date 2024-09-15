import 'package:flutter/material.dart';
import 'package:pineapp/views/pineAp/pineAppPage.dart';

class PineApHome extends StatefulWidget {
  final int page;

  PineApHome({required Key key, required this.page}) : super(key: key);

  @override
  PineApPageState createState() => PineApPageState();
}

class PineApPageState extends State<PineApHome> {
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
        return PineAPPage(); // Page Passive
      case 1:
        return Scaffold(
            body: Center(child: Text("Active Mode"))); // Page Active
      default:
        return Scaffold(
            body: Center(
                child: Text("Error"))); // Page par défaut en cas d'erreur
    }
  }
}
