// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
  id: _toInt(json['postid']),
  title: json['title'] as String,
  content: json['content'] as String,
  userId: _toInt(json['userid']),
  createTime: json['create_time'] as String,
  updateTime: json['update_time'] as String,
  status: _toInt(json['status']),
  appId: _toInt(json['appid']),
  sectionId: _toInt(json['section_id']),
  subSectionId: _toInt(json['sub_section_id']),
  sticky: _toInt(json['sticky']),
  popular: _toInt(json['popular']),
  featured: _toInt(json['featured']),
  videoUrl: json['video_url'] as String?,
  imageUrls: (json['img_url'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  score: json['score'] as String,
  paidReading: _toInt(json['paid_reading']),
  fileDownloadMethod: _toInt(json['file_download_method']),
  videoImage: json['video_img'] as String?,
  username: json['username'] as String,
  nickname: json['nickname'] as String,
  avatar: json['usertx'] as String,
  userTitles: (json['usertitle'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  sex: _toInt(json['sex']),
  signature: json['signature'] as String,
  exp: _toInt(json['exp']),
  sectionName: json['section_name'] as String,
  sectionIcon: json['section_icon'] as String?,
  subSectionName: json['sub_section_name'] as String,
  ipAddress: json['ip_address'] as String,
  sexName: json['sexName'] as String,
  isSectionModerator: _toInt(json['is_section_moderator']),
  badges: (json['badge'] as List<dynamic>?)
      ?.map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  isVip: json['vip'] as bool,
  hierarchy: json['hierarchy'] as String,
  createTimeAgo: json['create_time_ago'] as String,
  updateTimeAgo: json['update_time_ago'] as String,
  viewCount: _toInt(json['view']),
  thumbsCount: _toInt(json['thumbs']),
  commentCount: _toInt(json['comment']),
  rewardCount: _toInt(json['reward']),
  payersCount: _toInt(json['payers']),
);

// 添加类型转换辅助函数，处理字符串形式的数字
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
  'postid': instance.id,
  'title': instance.title,
  'content': instance.content,
  'userid': instance.userId,
  'create_time': instance.createTime,
  'update_time': instance.updateTime,
  'status': instance.status,
  'appid': instance.appId,
  'section_id': instance.sectionId,
  'sub_section_id': instance.subSectionId,
  'sticky': instance.sticky,
  'popular': instance.popular,
  'featured': instance.featured,
  'video_url': instance.videoUrl,
  'img_url': instance.imageUrls,
  'score': instance.score,
  'paid_reading': instance.paidReading,
  'file_download_method': instance.fileDownloadMethod,
  'video_img': instance.videoImage,
  'username': instance.username,
  'nickname': instance.nickname,
  'usertx': instance.avatar,
  'usertitle': instance.userTitles,
  'sex': instance.sex,
  'signature': instance.signature,
  'exp': instance.exp,
  'section_name': instance.sectionName,
  'section_icon': instance.sectionIcon,
  'sub_section_name': instance.subSectionName,
  'ip_address': instance.ipAddress,
  'sexName': instance.sexName,
  'is_section_moderator': instance.isSectionModerator,
  'badge': instance.badges,
  'vip': instance.isVip,
  'hierarchy': instance.hierarchy,
  'create_time_ago': instance.createTimeAgo,
  'update_time_ago': instance.updateTimeAgo,
  'view': instance.viewCount,
  'thumbs': instance.thumbsCount,
  'comment': instance.commentCount,
  'reward': instance.rewardCount,
  'payers': instance.payersCount,
};

SectionModel _$SectionModelFromJson(Map<String, dynamic> json) => SectionModel(
  id: _toInt(json['id']),
  name: json['section_name'] as String,
  icon: json['section_icon'] as String?,
  background: json['section_background'] as String?,
  description: json['section_description'] as String?,
  announcement: json['section_announcement'] as String?,
  createTime: json['create_time'] as String,
  forumSection: json['forum_section'] as List<dynamic>?,
  postCount: _toInt(json['postnum']),
  viewCount: _toInt(json['viewnum']),
  commentCount: _toInt(json['commentnum']),
  subSections: (json['sub_section'] as List<dynamic>?)
      ?.map((e) => SubSectionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SectionModelToJson(SectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'section_name': instance.name,
      'section_icon': instance.icon,
      'section_background': instance.background,
      'section_description': instance.description,
      'section_announcement': instance.announcement,
      'create_time': instance.createTime,
      'forum_section': instance.forumSection,
      'postnum': instance.postCount,
      'viewnum': instance.viewCount,
      'commentnum': instance.commentCount,
      'sub_section': instance.subSections,
    };

SubSectionModel _$SubSectionModelFromJson(Map<String, dynamic> json) =>
    SubSectionModel(
      id: _toInt(json['id']),
      name: json['section_name'] as String,
      icon: json['section_icon'] as String?,
    );

Map<String, dynamic> _$SubSectionModelToJson(SubSectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'section_name': instance.name,
      'section_icon': instance.icon,
    };
