import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../generated/models/dashboard/cards.g.dart';

@JsonSerializable()
class DashboardCards {
  final SystemStatus systemStatus;
  final DiskUsage diskUsage;
  final String clientsConnected;
  final String previousClients;
  final SSIDsSeen ssidsSeen;
  final MostPopularTraffic mostPopularTraffic;
  final int totalBandwidthUsed;
  final int reconScansRan;

  DashboardCards({
    required this.systemStatus,
    required this.diskUsage,
    required this.clientsConnected,
    required this.previousClients,
    required this.ssidsSeen,
    required this.mostPopularTraffic,
    required this.totalBandwidthUsed,
    required this.reconScansRan,
  });

  factory DashboardCards.fromJson(Map<String, dynamic> json) =>
      _$DashboardCardsFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardCardsToJson(this);
}

@JsonSerializable()
class SystemStatus {
  final String cpuUsage;
  final String memoryUsage;
  final String temperature;

  SystemStatus({
    required this.cpuUsage,
    required this.memoryUsage,
    required this.temperature,
  });

  factory SystemStatus.fromJson(Map<String, dynamic> json) =>
      _$SystemStatusFromJson(json);

  Map<String, dynamic> toJson() => _$SystemStatusToJson(this);
}

@JsonSerializable()
class DiskUsage {
  final String rootUsage;

  DiskUsage({required this.rootUsage});

  factory DiskUsage.fromJson(Map<String, dynamic> json) =>
      _$DiskUsageFromJson(json);

  Map<String, dynamic> toJson() => _$DiskUsageToJson(this);
}

@JsonSerializable()
class SSIDsSeen {
  final String totalSSIDs;
  final String currentSSIDs;

  SSIDsSeen({required this.totalSSIDs, required this.currentSSIDs});

  factory SSIDsSeen.fromJson(Map<String, dynamic> json) =>
      _$SSIDsSeenFromJson(json);

  Map<String, dynamic> toJson() => _$SSIDsSeenToJson(this);
}

@JsonSerializable()
class MostPopularTraffic {
  final String first;
  final String second;
  final String third;

  MostPopularTraffic(
      {required this.first, required this.second, required this.third});

  factory MostPopularTraffic.fromJson(Map<String, dynamic> json) =>
      _$MostPopularTrafficFromJson(json);

  Map<String, dynamic> toJson() => _$MostPopularTrafficToJson(this);
}
