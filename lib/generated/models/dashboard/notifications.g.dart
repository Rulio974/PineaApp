// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../models/dashboard/notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    NotificationItem(
      id: (json['id'] as num).toInt(),
      message: json['message'] as String?,
      level: (json['level'] as num?)?.toInt(),
      time: json['time'] as String?,
      read: json['read'] as bool?,
      displayed: json['displayed'] as bool?,
      moduleName: json['moduleName'] as String?,
    );

Map<String, dynamic> _$NotificationItemToJson(NotificationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'level': instance.level,
      'time': instance.time,
      'read': instance.read,
      'displayed': instance.displayed,
      'moduleName': instance.moduleName,
    };
