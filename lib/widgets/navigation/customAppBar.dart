import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/models/dashboard/notifications.dart';
import 'package:pineapp/views/notifications/notifications.dart';

class NotificationAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ApiService _apiService;
  final String title;
  final int currentIndex;
  final VoidCallback onMenuPressed;
  final ValueChanged<int> onDropdownChanged; // Callback pour remonter l'index
  final int
      dropdownType; // Ajoute un paramètre pour savoir de quel type de dropdown il s'agit (Recon ou PineAp)

  NotificationAppBar(
    this.title,
    this._apiService, {
    required this.onMenuPressed,
    required this.currentIndex,
    required this.onDropdownChanged,
    required this.dropdownType, // Paramètre pour distinguer les dropdowns
  });

  @override
  Size get preferredSize => const Size.fromHeight(60); // Hauteur définie

  @override
  _NotificationAppBarState createState() => _NotificationAppBarState();
}

class _NotificationAppBarState extends State<NotificationAppBar> {
  String selectedSubtitle = ''; // Sous-titre sélectionné

  @override
  void initState() {
    super.initState();
    selectedSubtitle = widget.title; // Définit le sous-titre initial
  }

  // Définir les éléments de dropdown en fonction de l'index
  // Ajoute un paramètre `dropdownType` pour différencier PineAp et Recon
  Map<int, List<String>> dropdownItems = {
    2: ['Passive', 'Active', 'Advanced', 'Clients', 'Filtering'], // PineAp page
    3: ['Scan', 'Handshake'], // Recon page
  };

  // Map des sous-titres pour chaque page
  Map<int, String> subtitles = {
    2: 'PineAp Suite',
    3: 'Recon Page',
  };

  // Méthode pour gérer la sélection
  void _onDropdownItemSelected(BuildContext context, String value) {
    setState(() {
      selectedSubtitle = value; // Mise à jour du sous-titre
    });

    // Utilisation de widget.dropdownType pour distinguer entre PineAp et Recon
    if (widget.dropdownType == 3) {
      // Logique pour Recon
      if (value == 'Scan') {
        widget.onDropdownChanged(0); // Remonte l'index 0 pour la page "Scan"
      } else if (value == 'Handshake') {
        widget
            .onDropdownChanged(1); // Remonte l'index 1 pour la page "Handshake"
      }
    } else if (widget.dropdownType == 2) {
      // Logique pour PineAp
      if (value == 'Passive') {
        widget.onDropdownChanged(0); // Index pour Passive
      } else if (value == 'Active') {
        widget.onDropdownChanged(1); // Index pour Active
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const HeroIcon(HeroIcons.cog6Tooth),
        onPressed: widget.onMenuPressed, // Ouvre le endDrawer via le callback
      ),
      centerTitle: true,
      title: GestureDetector(
        onTap: () async {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final offset = renderBox.localToGlobal(Offset.zero);

          // Sélectionne les items en fonction du type de page
          final selected = await showMenu<String>(
            context: context,
            position: RelativeRect.fromLTRB(
              offset.dx, // Alignement au start du texte
              offset.dy +
                  renderBox.size.height +
                  5, // En dessous avec un petit espace
              offset.dx +
                  renderBox.size.width, // Limiter la largeur du menu au texte
              0, // bas de l'écran
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Coins arrondis
            ),
            items: dropdownItems[widget.dropdownType]!
                .map((String choice) => PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    ))
                .toList(),
          );

          if (selected != null) {
            _onDropdownItemSelected(context, selected);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Aligner au début
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alignement au début
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.title, // Le titre reste fixe
                  style: const TextStyle(fontSize: 20),
                ),
                if (subtitles.containsKey(widget.dropdownType))
                  Row(children: [
                    // Affiche le sous-titre si disponible
                    Text(
                      selectedSubtitle.isNotEmpty
                          ? selectedSubtitle
                          : subtitles[widget.dropdownType]!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.start, // Aligné au début
                    ),
                    const SizedBox(width: 5),
                    const HeroIcon(
                      HeroIcons.chevronDown,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ]),
              ],
            ),
          ],
        ),
      ),
      actions: [
        FutureBuilder<List<NotificationItem>>(
          future: widget._apiService.getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationsPage(widget._apiService),
                    ),
                  );
                },
                icon: const HeroIcon(HeroIcons.bell),
              );
            } else if (snapshot.hasError) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationsPage(widget._apiService),
                    ),
                  );
                },
                icon: const HeroIcon(HeroIcons.bell),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final notifications = snapshot.data!;
              int notificationCount = notifications.length;

              return custom_badge.Badge(
                showBadge: notificationCount > 0,
                position: custom_badge.BadgePosition.topEnd(top: 0, end: 3),
                badgeContent: Text(
                  notificationCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NotificationsPage(widget._apiService),
                      ),
                    );
                  },
                  icon: const HeroIcon(HeroIcons.bell),
                ),
              );
            } else {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationsPage(widget._apiService),
                    ),
                  );
                },
                icon: const HeroIcon(HeroIcons.bell),
              );
            }
          },
        ),
      ],
    );
  }
}
