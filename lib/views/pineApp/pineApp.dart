import 'package:flutter/material.dart';

class PineApPage extends StatefulWidget {
  final int page;

  PineApPage({required Key key, required this.page}) : super(key: key);

  @override
  PineApPageState createState() => PineApPageState();
}

class PineApPageState extends State<PineApPage> {
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
      appBar: AppBar(
        title: Text("PineAp Page"),
      ),
      body: _buildBody(currentPageIndex), // Affiche la page correcte
    );
  }

  // Fonction pour retourner le bon contenu en fonction de l'index
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return Scaffold(
            body: Center(child: Text("Passive Mode"))); // Page Passive
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
