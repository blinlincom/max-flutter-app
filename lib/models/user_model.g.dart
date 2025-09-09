// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  nickname: json['nickname'] as String?,
  avatar: json['usertx'] as String?,
  money: (json['money'] as num?)?.toInt(),
  exp: (json['exp'] as num?)?.toInt(),
  integral: (json['integral'] as num?)?.toInt(),
  vipTime: json['viptime'] as String?,
  sex: (json['sex'] as num?)?.toInt(),
  sexName: json['sexName'] as String?,
  signature: json['signature'] as String?,
  title: (json['title'] as List<dynamic>?)?.map((e) => e as String).toList(),
  inviteCode: json['invitecode'] as String?,
  reasons: json['reasons'] as String?,
  reasonsTime: json['reasons_time'],
  reasonsBan: json['reasons_ban'] as String?,
  background: json['userbg'] as String?,
  ipAddress: json['ipaddress'] as String?,
  createTime: json['create_time'] as String?,
  hierarchy: json['hierarchy'] as String?,
  badges: (json['badge'] as List<dynamic>?)
      ?.map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  isVip: json['vip'] as bool?,
  signLastTime: json['signlasttime'] as String?,
  signToday: json['sign_today'] as bool?,
  seriesDays: (json['series_days'] as num?)?.toInt(),
  continuityDays: (json['continuity_days'] as num?)?.toInt(),
  invitationCount: json['invitationcount'] as String?,
  followersCount: json['followerscount'] as String?,
  fansCount: json['fanscount'] as String?,
  postCount: json['postcount'] as String?,
  likeCount: json['likecount'] as String?,
  commentCount: json['commentcount'] as String?,
  lastActivityTime: json['last_activity_time'] as String?,
  followStatus: (json['follow_status'] as num?)?.toInt(),
  isSectionModerator: (json['is_section_moderator'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'nickname': instance.nickname,
  'usertx': instance.avatar,
  'money': instance.money,
  'exp': instance.exp,
  'integral': instance.integral,
  'viptime': instance.vipTime,
  'sex': instance.sex,
  'sexName': instance.sexName,
  'signature': instance.signature,
  'title': instance.title,
  'invitecode': instance.inviteCode,
  'reasons': instance.reasons,
  'reasons_time': instance.reasonsTime,
  'reasons_ban': instance.reasonsBan,
  'userbg': instance.background,
  'ipaddress': instance.ipAddress,
  'create_time': instance.createTime,
  'hierarchy': instance.hierarchy,
  'badge': instance.badges,
  'vip': instance.isVip,
  'signlasttime': instance.signLastTime,
  'sign_today': instance.signToday,
  'series_days': instance.seriesDays,
  'continuity_days': instance.continuityDays,
  'invitationcount': instance.invitationCount,
  'followerscount': instance.followersCount,
  'fanscount': instance.fansCount,
  'postcount': instance.postCount,
  'likecount': instance.likeCount,
  'commentcount': instance.commentCount,
  'last_activity_time': instance.lastActivityTime,
  'follow_status': instance.followStatus,
  'is_section_moderator': instance.isSectionModerator,
};

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      userToken: json['usertoken'] as String,
      isSectionModerator: (json['is_section_moderator'] as num?)?.toInt(),
      isSign: (json['is_sign'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'usertoken': instance.userToken,
      'is_section_moderator': instance.isSectionModerator,
      'is_sign': instance.isSign,
    };

BadgeModel _$BadgeModelFromJson(Map<String, dynamic> json) => BadgeModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  icon: json['icon'] as String,
  type: (json['type'] as num).toInt(),
  expirationTime: json['expiration_time'] as String?,
);

Map<String, dynamic> _$BadgeModelToJson(BadgeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'type': instance.type,
      'expiration_time': instance.expirationTime,
    };
