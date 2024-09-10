// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../models/dashboard/cards.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardCards _$DashboardCardsFromJson(Map<String, dynamic> json) =>
    DashboardCards(
      systemStatus:
          SystemStatus.fromJson(json['systemStatus'] as Map<String, dynamic>),
      diskUsage: DiskUsage.fromJson(json['diskUsage'] as Map<String, dynamic>),
      clientsConnected: json['clientsConnected'] as String,
      previousClients: json['previousClients'] as String,
      ssidsSeen: SSIDsSeen.fromJson(json['ssidsSeen'] as Map<String, dynamic>),
      mostPopularTraffic: MostPopularTraffic.fromJson(
          json['mostPopularTraffic'] as Map<String, dynamic>),
      totalBandwidthUsed: (json['totalBandwidthUsed'] as num).toInt(),
      reconScansRan: (json['reconScansRan'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardCardsToJson(DashboardCards instance) =>
    <String, dynamic>{
      'systemStatus': instance.systemStatus,
      'diskUsage': instance.diskUsage,
      'clientsConnected': instance.clientsConnected,
      'previousClients': instance.previousClients,
      'ssidsSeen': instance.ssidsSeen,
      'mostPopularTraffic': instance.mostPopularTraffic,
      'totalBandwidthUsed': instance.totalBandwidthUsed,
      'reconScansRan': instance.reconScansRan,
    };

SystemStatus _$SystemStatusFromJson(Map<String, dynamic> json) => SystemStatus(
      cpuUsage: json['cpuUsage'] as String,
      memoryUsage: json['memoryUsage'] as String,
      temperature: json['temperature'] as String,
    );

Map<String, dynamic> _$SystemStatusToJson(SystemStatus instance) =>
    <String, dynamic>{
      'cpuUsage': instance.cpuUsage,
      'memoryUsage': instance.memoryUsage,
      'temperature': instance.temperature,
    };

DiskUsage _$DiskUsageFromJson(Map<String, dynamic> json) => DiskUsage(
      rootUsage: json['rootUsage'] as String,
    );

Map<String, dynamic> _$DiskUsageToJson(DiskUsage instance) => <String, dynamic>{
      'rootUsage': instance.rootUsage,
    };

SSIDsSeen _$SSIDsSeenFromJson(Map<String, dynamic> json) => SSIDsSeen(
      totalSSIDs: json['totalSSIDs'] as String,
      currentSSIDs: json['currentSSIDs'] as String,
    );

Map<String, dynamic> _$SSIDsSeenToJson(SSIDsSeen instance) => <String, dynamic>{
      'totalSSIDs': instance.totalSSIDs,
      'currentSSIDs': instance.currentSSIDs,
    };

MostPopularTraffic _$MostPopularTrafficFromJson(Map<String, dynamic> json) =>
    MostPopularTraffic(
      first: json['first'] as String,
      second: json['second'] as String,
      third: json['third'] as String,
    );

Map<String, dynamic> _$MostPopularTrafficToJson(MostPopularTraffic instance) =>
    <String, dynamic>{
      'first': instance.first,
      'second': instance.second,
      'third': instance.third,
    };
