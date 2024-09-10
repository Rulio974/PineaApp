import 'package:json_annotation/json_annotation.dart';

part '../../generated/models/recon/recon.g.dart';

@JsonSerializable()
class ReconScan {
  final int scan_id;
  final String date;

  ReconScan({
    required this.scan_id,
    required this.date,
  });

  factory ReconScan.fromJson(Map<String, dynamic> json) =>
      _$ReconScanFromJson(json);

  Map<String, dynamic> toJson() => _$ReconScanToJson(this);
}
