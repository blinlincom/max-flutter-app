import 'package:json_annotation/json_annotation.dart';

part 'stats_model.g.dart';

/// 统计数据模型
@JsonSerializable()
class StatsModel {
  @JsonKey(name: 'view_count')
  final int viewCount;

  @JsonKey(name: 'user_count')
  final int userCount;

  @JsonKey(name: 'today_user_count')
  final int todayUserCount;

  const StatsModel({
    required this.viewCount,
    required this.userCount,
    required this.todayUserCount,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) =>
      _$StatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatsModelToJson(this);
}
