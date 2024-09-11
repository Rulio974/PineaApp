import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/views/dashboard/dashboard.dart';
import 'package:pineapp/views/pineApp/pineApp.dart';
import 'package:pineapp/views/recon/recon.dart'; // Page Recon
import 'package:pineapp/widgets/navigation/customAppBar.dart'; // Page PineAp

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int _reconPageIndex = 0; // Index pour gérer la page Recon
  int _pineapPageIndex = 0; // Index pour gérer la page PineAp
  late ApiService _apiService;
  final dio = Dio();

  // Utilisation de GlobalKey pour accéder à l'état de ReconPage et PineApPage
  final GlobalKey<ReconPageState> _reconPageKey = GlobalKey<ReconPageState>();
  final GlobalKey<PineApPageState> _pineapPageKey =
      GlobalKey<PineApPageState>();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(dio, baseUrl: 'http://172.16.42.1:1471');
  }

  // Fonction pour gérer la modification de l'index dans Recon
  void _onReconPageChanged(int index) {
    setState(() {
      _reconPageIndex = index;
      _reconPageKey.currentState?.changePage(
          index); // Appelle la méthode changePage dans ReconPageState
    });
  }

  // Fonction pour gérer la modification de l'index dans PineAp
  void _onPineapPageChanged(int index) {
    setState(() {
      _pineapPageIndex = index;
      _pineapPageKey.currentState?.changePage(
          index); // Appelle la méthode changePage dans PineApPageState
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NotificationAppBar(
        _getPageTitle(),
        _apiService,
        currentIndex: _currentIndex,
        onMenuPressed: () {},
        onDropdownChanged: _currentIndex == 3
            ? _onReconPageChanged // Si sur Recon, changer l'index pour Recon
            : _onPineapPageChanged, // Si sur PineAp, changer l'index pour PineAp
        dropdownType: _currentIndex == 3 ? 3 : 2, // 3 pour Recon, 2 pour PineAp
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(),
          Center(child: Text('Campains')),
          PineApPage(
              key: _pineapPageKey, page: _pineapPageIndex), // Page PineAp
          ReconPage(key: _reconPageKey, page: _reconPageIndex), // Page Recon
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change l'index lors du tap
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.rectangleGroup),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.academicCap),
            label: 'Campains',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.briefcase),
            label: 'PineAp Suite',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.eye),
            label: 'Recon',
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Campains';
      case 2:
        return 'PineAp Suite';
      case 3:
        return 'Recon';
      default:
        return 'App';
    }
  }
}
