// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../models/recon/recon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconScan _$ReconScanFromJson(Map<String, dynamic> json) => ReconScan(
      scan_id: (json['scan_id'] as num).toInt(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$ReconScanToJson(ReconScan instance) => <String, dynamic>{
      'scan_id': instance.scan_id,
      'date': instance.date,
    };
