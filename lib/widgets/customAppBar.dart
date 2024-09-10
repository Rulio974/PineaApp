import 'package:flutter/material.dart';
import 'package:badges/badges.dart'
    as custom_badge; // Alias pour le package badges
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/models/dashboard/notifications.dart';
import 'package:pineapp/views/notifications/notifications.dart';

class NotificationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final ApiService _apiService;
  final String title;

  NotificationAppBar(this.title, this._apiService);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const HeroIcon(HeroIcons.bars3BottomLeft),
        ),
        const Expanded(child: SizedBox()), // Espace pour centrer le titre
        Text(
          title,
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        const Expanded(child: SizedBox()), // Espace pour centrer le titre
        FutureBuilder<List<NotificationItem>>(
          future: _apiService.getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return // Modifie ton AppBar pour inclure la navigation vers la page des notifications
                  IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsPage(_apiService),
                    ),
                  );
                },
                icon: HeroIcon(HeroIcons.bell),
              );
            } else if (snapshot.hasError) {
              return // Modifie ton AppBar pour inclure la navigation vers la page des notifications
                  IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsPage(_apiService),
                    ),
                  );
                },
                icon: const HeroIcon(HeroIcons.bell),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final notifications = snapshot.data!;
              int notificationCount = notifications.length;

              return custom_badge.Badge(
                showBadge: notificationCount >
                    0, // Affiche le badge seulement s'il y a des notifications
                position: custom_badge.BadgePosition.topEnd(top: 0, end: 3),
                badgeContent: Text(
                  notificationCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: // Modifie ton AppBar pour inclure la navigation vers la page des notifications
                    IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsPage(_apiService),
                      ),
                    );
                  },
                  icon: const HeroIcon(HeroIcons.bell),
                ),
              );
            } else {
              return // Modifie ton AppBar pour inclure la navigation vers la page des notifications
                  IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsPage(_apiService),
                    ),
                  );
                },
                icon: HeroIcon(HeroIcons.bell),
              );
            }
          },
        ),
      ],
    );
  }
}
