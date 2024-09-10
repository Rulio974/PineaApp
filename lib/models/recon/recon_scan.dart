import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../generated/models/recon/recon_scan.g.dart';

@JsonSerializable()
class APResults {
  final int scan_id;
  final String? ssid; // Nullable
  final String? bssid; // Nullable
  final num encryption; // Utilisation de num avec une valeur par défaut
  final int hidden;
  final int wps;
  final int channel;
  final int signal;
  final int data;
  final int first_seen;
  final int last_seen;
  final int last_seen_delta;
  final int probes;
  final int mfp;
  final List<ClientResults>? clients; // Nullable
  final int num_clients;

  APResults({
    required this.scan_id,
    this.ssid,
    this.bssid,
    this.encryption = 0, // Valeur par défaut si null
    this.hidden = 0, // Valeur par défaut si null
    this.wps = 0, // Valeur par défaut si null
    this.channel = 0, // Valeur par défaut si null
    this.signal = 0, // Valeur par défaut si null
    this.data = 0, // Valeur par défaut si null
    this.first_seen = 0, // Valeur par défaut si null
    this.last_seen = 0, // Valeur par défaut si null
    this.last_seen_delta = 0, // Valeur par défaut si null
    this.probes = 0, // Valeur par défaut si null
    this.mfp = 0, // Valeur par défaut si null
    this.clients,
    this.num_clients = 0, // Valeur par défaut si null
  });

  // Méthode générée pour convertir depuis JSON
  factory APResults.fromJson(Map<String, dynamic> json) =>
      _$APResultsFromJson(json);

  // Méthode générée pour convertir vers JSON
  Map<String, dynamic> toJson() => _$APResultsToJson(this);
}

@JsonSerializable()
class ClientResults {
  final int? scan_id; // Nullable
  final String? client_mac; // Nullable
  final String? ap_mac; // Nullable
  final int? ap_channel; // Nullable
  final int? data; // Nullable
  final int? broadcast_probes; // Nullable
  final int? direct_probes; // Nullable
  final int? first_seen; // Nullable
  final int? last_seen; // Nullable
  final int? last_seen_delta; // Nullable
  final String? ssid; // Nullable

  ClientResults({
    this.scan_id,
    this.client_mac,
    this.ap_mac,
    this.ap_channel,
    this.data,
    this.broadcast_probes,
    this.direct_probes,
    this.first_seen,
    this.last_seen,
    this.last_seen_delta,
    this.ssid,
  });

  // Méthode générée pour convertir depuis JSON
  factory ClientResults.fromJson(Map<String, dynamic> json) =>
      _$ClientResultsFromJson(json);

  // Méthode générée pour convertir vers JSON
  Map<String, dynamic> toJson() => _$ClientResultsToJson(this);
}
