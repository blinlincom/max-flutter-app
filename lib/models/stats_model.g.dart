// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsModel _$StatsModelFromJson(Map<String, dynamic> json) => StatsModel(
  viewCount: (json['view_count'] as num).toInt(),
  userCount: (json['user_count'] as num).toInt(),
  todayUserCount: (json['today_user_count'] as num).toInt(),
);

Map<String, dynamic> _$StatsModelToJson(StatsModel instance) =>
    <String, dynamic>{
      'view_count': instance.viewCount,
      'user_count': instance.userCount,
      'today_user_count': instance.todayUserCount,
    };
