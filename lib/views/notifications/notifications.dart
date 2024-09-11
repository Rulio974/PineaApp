import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/models/dashboard/notifications.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  final ApiService apiService;

  NotificationsPage(this.apiService);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationItem>> _notificationsFuture;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = widget.apiService.getNotifications();
  }

  Future<void> _deleteNotification(int id) async {
    await widget.apiService.deleteNotification(id);
    setState(() {
      _notificationsFuture = widget.apiService.getNotifications();
    });
  }

  // Fonction de tri des notifications en fonction de l'heure
  List<NotificationItem> _sortNotifications(
      List<NotificationItem> notifications) {
    notifications.sort((a, b) {
      DateTime dateA = DateTime.parse(a.time!);
      DateTime dateB = DateTime.parse(b.time!);
      return _isAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
    return notifications;
  }

  // Fonction pour détecter les adresses MAC et appliquer un style avec padding et marge
  List<InlineSpan> _highlightMacAddresses(String message) {
    final macRegex = RegExp(r'([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})');
    final matches = macRegex.allMatches(message);

    List<InlineSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Texte avant l'adresse MAC
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: message.substring(lastMatchEnd, match.start),
          style: TextStyle(color: Colors.black),
        ));
      }

      // Adresse MAC détectée avec padding et margin
      spans.add(WidgetSpan(
        alignment:
            PlaceholderAlignment.baseline, // Alignement sur la ligne de base
        baseline:
            TextBaseline.alphabetic, // Utilise la ligne de base alphabétique
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            message.substring(match.start, match.end),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ));

      lastMatchEnd = match.end;
    }

    // Ajouter le reste du message après la dernière adresse MAC
    if (lastMatchEnd < message.length) {
      spans.add(TextSpan(
        text: message.substring(lastMatchEnd),
        style: TextStyle(color: Colors.black),
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HeroIcon(HeroIcons.arrowLeft), // Choisis l'icône souhaitée
          onPressed: () {
            Navigator.pop(context); // Action de retour
          },
        ),
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: HeroIcon(
                _isAscending ? HeroIcons.barsArrowDown : HeroIcons.barsArrowUp),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending; // Inverse l'ordre de tri
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<NotificationItem>>(
              future: _notificationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucune notification."));
                } else {
                  // Trier les notifications avant de les afficher
                  List<NotificationItem> sortedNotifications =
                      _sortNotifications(snapshot.data!);

                  return ListView.builder(
                    itemCount: sortedNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = sortedNotifications[index];
                      return Column(
                        children: [
                          Dismissible(
                            key: Key(notification.id.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              _deleteNotification(notification.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Notification supprimée")),
                              );
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              width: _width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: notification.message!
                                                  .contains('Handshake')
                                              ? const Color(0xff078f2b)
                                              : (notification.level == 1
                                                  ? const Color(0xfffa9f26)
                                                  : const Color(0xff0091ca)),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            notification.message!
                                                    .contains('Handshake')
                                                ? "Handshake"
                                                : (notification.level == 1
                                                    ? "Warning"
                                                    : "Informal"),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      const SizedBox(width: 10),
                                      HeroIcon(HeroIcons.clock),
                                      const SizedBox(width: 5),
                                      Text(
                                        timeago.format(
                                          DateTime.parse(notification.time!),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                      'Concerned module: ${notification.moduleName ?? "system"}'),
                                  const SizedBox(height: 5),
                                  // Utilisation de RichText pour appliquer les styles avec padding et marge
                                  RichText(
                                    text: TextSpan(
                                      children: _highlightMacAddresses(
                                          notification.message!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
