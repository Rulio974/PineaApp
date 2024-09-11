import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pineapp/core/helpers/getLastScanId_helper.dart';
import 'package:pineapp/core/services/api/api_service.dart';
import 'package:pineapp/core/utils/secure_token.dart';
import 'package:pineapp/models/dashboard/cards.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pineapp/models/dashboard/notifications.dart';
import 'package:pineapp/models/recon/recon_scan.dart';
import 'package:pineapp/widgets/navigation/customAppBar.dart';
import 'package:pineapp/widgets/dashboard/cards.dart';
import 'package:heroicons/heroicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ApiService _apiService;
  late Future<List<dynamic>> _dashboardFuture;
  bool isAlwaysCapturingHandshakes = false;
  Map<int, bool> isCapturingHandshakePerSSID = {};
  bool isScanning = false;
  int handshakesCaptured = 0;
  String scanDuration = '10 Seconds';
  List<APResults> wifiList = [];
  List<APResults> filteredWifiList = [];
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _apiService = ApiService(dio, baseUrl: 'http://172.16.42.1:1471');

    // Regrouper tous les futures à charger
    _dashboardFuture = Future.wait([
      _apiService.getDashboardCards(),
      fetchLastScanResults(),
      _apiService.getNotifications(),
    ]);
  }

  Future<void> fetchLastScanResults() async {
    int lastScanId = await getLastScanId(_apiService);
    if (lastScanId != -1) {
      try {
        final response = await Dio().get(
            'http://172.16.42.1:1471/api/recon/scans/$lastScanId',
            options:
                Options(headers: {"Authorization": "${await getToken()}"}));

        final List<dynamic> apResultsJson = response.data['APResults'];

        setState(() {
          wifiList = apResultsJson
              .map((item) => APResults.fromJson(item as Map<String, dynamic>))
              .toList();
          filteredWifiList = wifiList;
        });
      } catch (e) {
        print('Erreur lors de la récupération des résultats du scan : $e');
      }
    } else {
      print('Aucun scan trouvé.');
    }
  }

  Future<void> _deleteNotification(int id) async {
    try {
      await _apiService.deleteNotification(id);
      setState(() {
        _dashboardFuture = Future.wait([
          _apiService.getDashboardCards(),
          fetchLastScanResults(),
          _apiService.getNotifications(),
        ]);
      });
    } catch (e) {
      print('Erreur lors de la suppression de la notification : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f6),
      body: FutureBuilder<List<dynamic>>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche les squelettes pour toutes les sections
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Skeletonizer(child: _buildStatusCardsSkeleton()),
                    const SizedBox(height: 20),
                    Skeletonizer(child: _buildStatusCardsSkeleton()),
                    const SizedBox(height: 20),
                    Skeletonizer(child: _buildStatusCardsSkeleton()),
                    const SizedBox(height: 20),
                    Skeletonizer(child: _buildGraphsSkeleton()),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Une fois les données chargées, affiche les widgets réels
            final dashboardData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusCards(dashboardData[
                        0]), // Affichage réel des cartes du statut
                    const SizedBox(height: 20),
                    // _buildNotificationsSection(
                    //     dashboardData[2]), // Notifications réelles
                    // const SizedBox(height: 10),
                    _buildGraphsSection(), // Graphiques réels
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Status Cards with Skeleton loading
  Widget _buildStatusCards(DashboardCards cards) {
    double espacement = 10;
    return Skeletonizer(
      enabled: cards == null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              "System Status",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            children: [
              StatusCard(
                  text: "CPU usage",
                  heroIcon: HeroIcons.cpuChip,
                  data: cards.systemStatus.cpuUsage,
                  color: Colors.blue),
              StatusCard(
                text: "Memory usage",
                heroIcon: HeroIcons.folder,
                data: cards.systemStatus.memoryUsage,
                color: Colors.red,
              ),
            ],
          ),
          SizedBox(height: espacement),
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              "Clients Status",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            children: [
              StatusCard(
                  text: "Connected",
                  heroIcon: HeroIcons.link,
                  data: cards?.clientsConnected ?? '',
                  color: Colors.green),
              StatusCard(
                text: "Previous",
                heroIcon: HeroIcons.backward,
                data: cards?.previousClients ?? '',
                color: Colors.yellow,
              ),
            ],
          ),
          SizedBox(height: espacement),
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              "SSID",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            children: [
              StatusCard(
                  text: "Total SSIDs",
                  heroIcon: HeroIcons.inboxStack,
                  data: cards?.clientsConnected ?? '',
                  color: Colors.orange),
              StatusCard(
                text: "Current SSIDs",
                heroIcon: HeroIcons.bars3BottomRight,
                data: cards?.previousClients ?? '',
                color: Colors.blueGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCardsSkeleton() {
    return Row(
      children: [
        StatusCard(
          text: "",
          heroIcon: HeroIcons.checkCircle,
          data: "Loading...",
          color: Colors.grey,
        ),
        StatusCard(
          text: "",
          heroIcon: HeroIcons.checkCircle,
          data: "Loading...",
          color: Colors.grey,
        ),
      ],
    );
  }

  // Squelette pour les graphiques
  Widget _buildGraphsSkeleton() {
    return Skeletonizer(
      child: SizedBox(
        height: 300,
        child: Row(
          children: [
            Container(
              width: 150,
              height: 150,
              color: Colors.grey,
            ),
            const SizedBox(width: 16),
            Container(
              width: 150,
              height: 150,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphsSection() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 0),
                child: Text(
                  "Statistics",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildBarChart(),
              const SizedBox(
                height: 20,
              ),
              _buildPieChart()
            ],
          ),
        ));
  }

  // Graphique circulaire
  Widget _buildPieChart() {
    int clients =
        wifiList.fold(0, (sum, item) => sum + (item.clients?.length ?? 0));
    int accessPoints = wifiList.length;
    int unassociated =
        wifiList.where((item) => (item.clients?.isEmpty ?? true)).length;

    return SizedBox(
      height: 300, // Fixe la hauteur
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wireless Landscape',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Légende en haut à droite sous forme de colonne
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.green,
                          ),
                          SizedBox(width: 5),
                          const Text('Clients'),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 5),
                          const Text('Access Points'),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.red,
                          ),
                          SizedBox(width: 5),
                          const Text('Unassociated'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                            value: clients.toDouble(),
                            color: Colors.green,
                            title: 'Clients',
                            titleStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        PieChartSectionData(
                            value: accessPoints.toDouble(),
                            color: Colors.blue,
                            title: 'Access Points'),
                        PieChartSectionData(
                            value: unassociated.toDouble(),
                            color: Colors.red,
                            title: 'Unassociated'),
                      ],
                      sectionsSpace: 5,
                      centerSpaceRadius: 60,
                      borderData: FlBorderData(show: true),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Graphique en barres pour les 5 channels les plus utilisés
  Widget _buildBarChart() {
    // Comptabiliser les occurrences de chaque channel
    Map<int, int> channelUsage = {};
    wifiList.forEach((ap) {
      channelUsage[ap.channel] = (channelUsage[ap.channel] ?? 0) + 1;
    });

    // Trier les channels par ordre décroissant d'utilisation
    List<MapEntry<int, int>> sortedChannelUsage = channelUsage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Prendre uniquement les 5 premiers channels les plus utilisés
    List<BarChartGroupData> barGroups = sortedChannelUsage.take(5).map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
            width: 15, // La largeur de chaque barre
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return SizedBox(
      height: 300,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top 5 Channels Usage',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    barGroups: barGroups, // Affiche les 5 premiers channels
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(value.toInt().toString());
                            },
                          ),
                        ),
                        leftTitles:
                            const AxisTitles(drawBelowEverything: false),
                        topTitles:
                            const AxisTitles(drawBelowEverything: false)),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
