import 'package:flutter/material.dart';
import 'package:pineapp/views/pineAp/clients.dart';
import 'package:pineapp/views/pineAp/entreprise.dart';
import 'package:pineapp/views/pineAp/evilWpa.dart';
import 'package:pineapp/views/pineAp/filtering.dart';
import 'package:pineapp/views/pineAp/impersonation.dart';
import 'package:pineapp/views/pineAp/openAp.dart';
import 'package:pineapp/views/pineAp/pineAppPage.dart';

class PineApHome extends StatefulWidget {
  final int page;

  PineApHome({required Key key, required this.page}) : super(key: key);

  @override
  PineApPageState createState() => PineApPageState();
}

class PineApPageState extends State<PineApHome> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.page;
  }

  void changePage(int newIndex) {
    setState(() {
      currentPageIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(currentPageIndex),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return PineAPPage();
      case 1:
        return OpenApPage();
      case 2:
        return EvilWpaPage();
      case 3:
        return EntreprisePage();
      case 4:
        return ImpersonationPage();
      case 5:
        return ClientsPage();
      case 6:
        return FilteringPage();
      default:
        return const Scaffold(body: Center(child: Text("Error")));
    }
  }
}
