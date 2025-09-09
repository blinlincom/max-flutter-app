import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// 用户信息模型
@JsonSerializable()
class UserModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'nickname')
  final String? nickname;

  @JsonKey(name: 'usertx')
  final String? avatar;

  @JsonKey(name: 'money')
  final int? money;

  @JsonKey(name: 'exp')
  final int? exp;

  @JsonKey(name: 'integral')
  final int? integral;

  @JsonKey(name: 'viptime')
  final String? vipTime;

  @JsonKey(name: 'sex')
  final int? sex;

  @JsonKey(name: 'sexName')
  final String? sexName;

  @JsonKey(name: 'signature')
  final String? signature;

  @JsonKey(name: 'title')
  final List<String>? title;

  @JsonKey(name: 'invitecode')
  final String? inviteCode;

  @JsonKey(name: 'reasons')
  final String? reasons;

  @JsonKey(name: 'reasons_time')
  final dynamic reasonsTime;

  @JsonKey(name: 'reasons_ban')
  final String? reasonsBan;

  @JsonKey(name: 'userbg')
  final String? background;

  @JsonKey(name: 'ipaddress')
  final String? ipAddress;

  @JsonKey(name: 'create_time')
  final String? createTime;

  @JsonKey(name: 'hierarchy')
  final String? hierarchy;

  @JsonKey(name: 'badge')
  final List<BadgeModel>? badges;

  @JsonKey(name: 'vip')
  final bool? isVip;

  @JsonKey(name: 'signlasttime')
  final String? signLastTime;

  @JsonKey(name: 'sign_today')
  final bool? signToday;

  @JsonKey(name: 'series_days')
  final int? seriesDays;

  @JsonKey(name: 'continuity_days')
  final int? continuityDays;

  @JsonKey(name: 'invitationcount')
  final String? invitationCount;

  @JsonKey(name: 'followerscount')
  final String? followersCount;

  @JsonKey(name: 'fanscount')
  final String? fansCount;

  @JsonKey(name: 'postcount')
  final String? postCount;

  @JsonKey(name: 'likecount')
  final String? likeCount;

  @JsonKey(name: 'commentcount')
  final String? commentCount;

  @JsonKey(name: 'last_activity_time')
  final String? lastActivityTime;

  @JsonKey(name: 'follow_status')
  final int? followStatus;

  @JsonKey(name: 'is_section_moderator')
  final int? isSectionModerator;

  const UserModel({
    required this.id,
    required this.username,
    this.nickname,
    this.avatar,
    this.money,
    this.exp,
    this.integral,
    this.vipTime,
    this.sex,
    this.sexName,
    this.signature,
    this.title,
    this.inviteCode,
    this.reasons,
    this.reasonsTime,
    this.reasonsBan,
    this.background,
    this.ipAddress,
    this.createTime,
    this.hierarchy,
    this.badges,
    this.isVip,
    this.signLastTime,
    this.signToday,
    this.seriesDays,
    this.continuityDays,
    this.invitationCount,
    this.followersCount,
    this.fansCount,
    this.postCount,
    this.likeCount,
    this.commentCount,
    this.lastActivityTime,
    this.followStatus,
    this.isSectionModerator,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

/// 用户登录响应模型
@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'usertoken')
  final String userToken;

  @JsonKey(name: 'is_section_moderator')
  final int? isSectionModerator;

  @JsonKey(name: 'is_sign')
  final int? isSign;

  const LoginResponse({
    required this.id,
    required this.username,
    required this.userToken,
    this.isSectionModerator,
    this.isSign,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

/// 徽章模型
@JsonSerializable()
class BadgeModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'icon')
  final String icon;

  @JsonKey(name: 'type')
  final int type;

  @JsonKey(name: 'expiration_time')
  final String? expirationTime;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    this.expirationTime,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) =>
      _$BadgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeModelToJson(this);
}
