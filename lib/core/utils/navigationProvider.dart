import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _currentIndex = 0;
  int _pineapPageIndex = 0;
  int _reconPageIndex = 0;

  int get currentIndex => _currentIndex;
  int get pineapPageIndex => _pineapPageIndex;
  int get reconPageIndex => _reconPageIndex;

  String get reconSubtitle => _reconPageIndex == 0 ? 'Scanning' : 'Handshake';
  String get pineapSubtitle => [
        'PineAp',
        'Open Ap',
        'Evil WPA',
        'Entreprise',
        'Impersonation',
        'Clients',
        'Filtering'
      ][_pineapPageIndex];

  void navigateTo(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void changeReconPage(int index) {
    _reconPageIndex = index;
    notifyListeners();
  }

  void changePineapPage(int index) {
    _pineapPageIndex = index;
    notifyListeners();
  }
}
