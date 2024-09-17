import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/core/utils/navigationProvider.dart';
import 'package:pineapp/views/dashboard/dashboard.dart';
import 'package:pineapp/views/pineAp/pineApHome.dart';
import 'package:pineapp/views/recon/recon.dart';
import 'package:pineapp/widgets/navigation/customAppBar.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final dio = Dio();
  late final ApiService _apiService;

  Home() {
    _apiService = ApiService(dio, baseUrl: 'http://172.16.42.1:1471');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          appBar: NotificationAppBar(
            _getPageTitle(navigationProvider.currentIndex),
            _apiService,
            currentIndex: navigationProvider.currentIndex,
            onMenuPressed: () {},
            onDropdownChanged: navigationProvider.currentIndex == 3
                ? navigationProvider.changeReconPage
                : navigationProvider.changePineapPage,
            dropdownType: navigationProvider.currentIndex == 3
                ? 3
                : (navigationProvider.currentIndex == 2 ? 2 : 0),
            currentSubtitle: navigationProvider.currentIndex == 3
                ? navigationProvider.reconSubtitle
                : (navigationProvider.currentIndex == 2
                    ? navigationProvider.pineapSubtitle
                    : null),
          ),
          body: IndexedStack(
            index: navigationProvider.currentIndex,
            children: [
              DashboardPage(),
              Center(child: Text('Campains')),
              PineApHome(
                  key: GlobalKey(), page: navigationProvider.pineapPageIndex),
              ReconPage(
                  key: GlobalKey(), page: navigationProvider.reconPageIndex),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navigationProvider.currentIndex,
            onTap: navigationProvider.navigateTo,
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
      },
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
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
