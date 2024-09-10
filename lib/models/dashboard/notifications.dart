import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../generated/models/dashboard/notifications.g.dart';

@JsonSerializable()
class NotificationItem {
  final int id;
  final String? message; // Permettre la valeur 'null'
  final int? level;
  final String? time; // Permettre la valeur 'null'
  final bool? read;
  final bool? displayed;
  final String? moduleName; // Permettre la valeur 'null'

  NotificationItem({
    required this.id,
    this.message, // Nullable
    this.level,
    this.time, // Nullable
    this.read,
    this.displayed,
    this.moduleName, // Nullable
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationItemToJson(this);
}
