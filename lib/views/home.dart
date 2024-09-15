import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/views/dashboard/dashboard.dart';
import 'package:pineapp/views/pineAp/pineApHome.dart';
import 'package:pineapp/views/recon/recon.dart'; // Page Recon
import 'package:pineapp/widgets/navigation/customAppBar.dart'; // Page PineAp

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int _reconPageIndex = 0;
  int _pineapPageIndex = 0;
  String _reconSubtitle = 'Scanning';
  String _pineapSubtitle = 'Open Ap';
  late ApiService _apiService;
  final dio = Dio();

  final GlobalKey<ReconPageState> _reconPageKey = GlobalKey<ReconPageState>();
  final GlobalKey<PineApPageState> _pineapPageKey =
      GlobalKey<PineApPageState>();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(dio, baseUrl: 'http://172.16.42.1:1471');
  }

  void _onReconPageChanged(int index) {
    setState(() {
      _reconPageIndex = index;
      _reconSubtitle = index == 0 ? 'Scanning' : 'Handshake';
      _reconPageKey.currentState?.changePage(index);
    });
  }

  void _onPineapPageChanged(int index) {
    setState(() {
      _pineapPageIndex = index;
      _pineapSubtitle = [
        'PineAp',
        'Open Ap',
        'Evil WPA',
        'Entreprise',
        'Impersonation',
        'Clients',
        'Filtering'
      ][index];
      _pineapPageKey.currentState?.changePage(index);
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
        onDropdownChanged:
            _currentIndex == 3 ? _onReconPageChanged : _onPineapPageChanged,
        dropdownType: _currentIndex == 3 ? 3 : (_currentIndex == 2 ? 2 : 0),
        currentSubtitle: _currentIndex == 3
            ? _reconSubtitle
            : (_currentIndex == 2 ? _pineapSubtitle : null),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(),
          Center(child: Text('Campains')),
          PineApHome(key: _pineapPageKey, page: _pineapPageIndex),
          ReconPage(key: _reconPageKey, page: _reconPageIndex),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
