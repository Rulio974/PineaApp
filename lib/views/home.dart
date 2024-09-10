import 'package:flutter/material.dart';
import 'package:pineapp/views/dashboard/dashboard.dart';
import 'package:pineapp/views/recon/recon.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 3;
  final List<Widget> _pages = [
    DashboardPage(),
    const Center(
        child: Text(
      'Dashboard',
    )),
    const Center(child: Text('Notifications')),
    ReconPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex],
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
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Campains',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi),
            label: 'PineAP',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility),
            label: 'Recon',
          ),
        ],
      ),
    );
  }
}
