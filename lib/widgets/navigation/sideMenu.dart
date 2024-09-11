import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SideMenu extends StatelessWidget {
  final Function(int) onItemSelected;

  SideMenu({required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: HeroIcon(HeroIcons.rectangleGroup),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              onItemSelected(0);
            },
          ),
          ListTile(
            leading: HeroIcon(HeroIcons.academicCap),
            title: Text('Campains'),
            onTap: () {
              Navigator.pop(context);
              onItemSelected(1);
            },
          ),
          ListTile(
            leading: HeroIcon(HeroIcons.briefcase),
            title: Text('PineAp Suite'),
            onTap: () {
              Navigator.pop(context);
              onItemSelected(2);
            },
          ),
          ListTile(
            leading: HeroIcon(HeroIcons.eye),
            title: Text('Recon'),
            onTap: () {
              Navigator.pop(context);
              onItemSelected(3);
            },
          ),
        ],
      ),
    );
  }
}
