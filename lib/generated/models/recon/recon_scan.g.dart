// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../models/recon/recon_scan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APResults _$APResultsFromJson(Map<String, dynamic> json) => APResults(
      scan_id: (json['scan_id'] as num).toInt(),
      ssid: json['ssid'] as String?,
      bssid: json['bssid'] as String?,
      encryption: json['encryption'] as num? ?? 0,
      hidden: (json['hidden'] as num?)?.toInt() ?? 0,
      wps: (json['wps'] as num?)?.toInt() ?? 0,
      channel: (json['channel'] as num?)?.toInt() ?? 0,
      signal: (json['signal'] as num?)?.toInt() ?? 0,
      data: (json['data'] as num?)?.toInt() ?? 0,
      first_seen: (json['first_seen'] as num?)?.toInt() ?? 0,
      last_seen: (json['last_seen'] as num?)?.toInt() ?? 0,
      last_seen_delta: (json['last_seen_delta'] as num?)?.toInt() ?? 0,
      probes: (json['probes'] as num?)?.toInt() ?? 0,
      mfp: (json['mfp'] as num?)?.toInt() ?? 0,
      clients: (json['clients'] as List<dynamic>?)
          ?.map((e) => ClientResults.fromJson(e as Map<String, dynamic>))
          .toList(),
      num_clients: (json['num_clients'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$APResultsToJson(APResults instance) => <String, dynamic>{
      'scan_id': instance.scan_id,
      'ssid': instance.ssid,
      'bssid': instance.bssid,
      'encryption': instance.encryption,
      'hidden': instance.hidden,
      'wps': instance.wps,
      'channel': instance.channel,
      'signal': instance.signal,
      'data': instance.data,
      'first_seen': instance.first_seen,
      'last_seen': instance.last_seen,
      'last_seen_delta': instance.last_seen_delta,
      'probes': instance.probes,
      'mfp': instance.mfp,
      'clients': instance.clients,
      'num_clients': instance.num_clients,
    };

ClientResults _$ClientResultsFromJson(Map<String, dynamic> json) =>
    ClientResults(
      scan_id: (json['scan_id'] as num?)?.toInt(),
      client_mac: json['client_mac'] as String?,
      ap_mac: json['ap_mac'] as String?,
      ap_channel: (json['ap_channel'] as num?)?.toInt(),
      data: (json['data'] as num?)?.toInt(),
      broadcast_probes: (json['broadcast_probes'] as num?)?.toInt(),
      direct_probes: (json['direct_probes'] as num?)?.toInt(),
      first_seen: (json['first_seen'] as num?)?.toInt(),
      last_seen: (json['last_seen'] as num?)?.toInt(),
      last_seen_delta: (json['last_seen_delta'] as num?)?.toInt(),
      ssid: json['ssid'] as String?,
    );

Map<String, dynamic> _$ClientResultsToJson(ClientResults instance) =>
    <String, dynamic>{
      'scan_id': instance.scan_id,
      'client_mac': instance.client_mac,
      'ap_mac': instance.ap_mac,
      'ap_channel': instance.ap_channel,
      'data': instance.data,
      'broadcast_probes': instance.broadcast_probes,
      'direct_probes': instance.direct_probes,
      'first_seen': instance.first_seen,
      'last_seen': instance.last_seen,
      'last_seen_delta': instance.last_seen_delta,
      'ssid': instance.ssid,
    };
