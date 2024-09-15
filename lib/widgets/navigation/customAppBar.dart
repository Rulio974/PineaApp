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
  final ValueChanged<int> onDropdownChanged;
  final int dropdownType;
  final String? currentSubtitle;

  NotificationAppBar(
    this.title,
    this._apiService, {
    required this.onMenuPressed,
    required this.currentIndex,
    required this.onDropdownChanged,
    required this.dropdownType,
    this.currentSubtitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  _NotificationAppBarState createState() => _NotificationAppBarState();
}

class _NotificationAppBarState extends State<NotificationAppBar> {
  late String selectedSubtitle;

  @override
  void initState() {
    super.initState();
    selectedSubtitle = widget.currentSubtitle ?? _getInitialSubtitle();
  }

  @override
  void didUpdateWidget(NotificationAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentSubtitle != oldWidget.currentSubtitle) {
      selectedSubtitle = widget.currentSubtitle ?? _getInitialSubtitle();
    }
  }

  String _getInitialSubtitle() {
    if (widget.dropdownType == 2) return 'PineAp';
    if (widget.dropdownType == 3) return 'Scanning';
    return '';
  }

  Map<int, List<String>> dropdownItems = {
    2: [
      'PineAp',
      'Open Ap',
      'Evil WPA',
      'Entreprise',
      'Impersonation',
      'Clients',
      'Filtering'
    ],
    3: ['Scanning', 'Handshake'],
  };

  Map<int, String> subtitles = {
    2: 'PineAp Suite',
    3: 'Recon Page',
  };

  void _onDropdownItemSelected(BuildContext context, String value) {
    setState(() {
      selectedSubtitle = value;
    });

    if (widget.dropdownType == 3) {
      widget.onDropdownChanged(value == 'Scan' ? 0 : 1);
    } else if (widget.dropdownType == 2) {
      widget.onDropdownChanged(dropdownItems[2]!.indexOf(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showDropdown = widget.dropdownType == 2 || widget.dropdownType == 3;

    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const HeroIcon(HeroIcons.cog6Tooth),
        onPressed: widget.onMenuPressed,
      ),
      centerTitle: false,
      title: showDropdown
          ? GestureDetector(
              onTap: () async {
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final offset = renderBox.localToGlobal(Offset.zero);

                final selected = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    offset.dx,
                    offset.dy + renderBox.size.height + 5,
                    offset.dx + renderBox.size.width,
                    0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Row(children: [
                        Text(
                          selectedSubtitle,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.start,
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
            )
          : Text(widget.title),
      actions: [
        FutureBuilder<List<NotificationItem>>(
          future: widget._apiService.getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                margin: EdgeInsets.only(right: 10),
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
            } else if (snapshot.hasError) {
              return Container(
                  margin: EdgeInsets.only(right: 10),
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
                  ));
            } else if (snapshot.hasData && snapshot.data != null) {
              final notifications = snapshot.data!;
              int notificationCount = notifications.length;

              return custom_badge.Badge(
                  showBadge: notificationCount > 0,
                  position: custom_badge.BadgePosition.topEnd(top: 0, end: 14),
                  badgeContent: Text(
                    notificationCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
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
                  ));
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
