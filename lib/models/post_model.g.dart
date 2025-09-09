// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
  id: (json['postid'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String,
  userId: (json['userid'] as num).toInt(),
  createTime: json['create_time'] as String,
  updateTime: json['update_time'] as String,
  status: (json['status'] as num).toInt(),
  appId: (json['appid'] as num).toInt(),
  sectionId: (json['section_id'] as num).toInt(),
  subSectionId: (json['sub_section_id'] as num).toInt(),
  sticky: (json['sticky'] as num).toInt(),
  popular: (json['popular'] as num).toInt(),
  featured: (json['featured'] as num).toInt(),
  videoUrl: json['video_url'] as String?,
  imageUrls: (json['img_url'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  score: json['score'] as String,
  paidReading: (json['paid_reading'] as num).toInt(),
  fileDownloadMethod: (json['file_download_method'] as num).toInt(),
  videoImage: json['video_img'] as String?,
  username: json['username'] as String,
  nickname: json['nickname'] as String,
  avatar: json['usertx'] as String,
  userTitles: (json['usertitle'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  sex: (json['sex'] as num).toInt(),
  signature: json['signature'] as String,
  exp: (json['exp'] as num).toInt(),
  sectionName: json['section_name'] as String,
  sectionIcon: json['section_icon'] as String?,
  subSectionName: json['sub_section_name'] as String,
  ipAddress: json['ip_address'] as String,
  sexName: json['sexName'] as String,
  isSectionModerator: (json['is_section_moderator'] as num).toInt(),
  badges: (json['badge'] as List<dynamic>?)
      ?.map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  isVip: json['vip'] as bool,
  hierarchy: json['hierarchy'] as String,
  createTimeAgo: json['create_time_ago'] as String,
  updateTimeAgo: json['update_time_ago'] as String,
  viewCount: (json['view'] as num).toInt(),
  thumbsCount: (json['thumbs'] as num).toInt(),
  commentCount: (json['comment'] as num).toInt(),
  rewardCount: (json['reward'] as num).toInt(),
  payersCount: (json['payers'] as num).toInt(),
);

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
  id: (json['id'] as num).toInt(),
  name: json['section_name'] as String,
  icon: json['section_icon'] as String?,
  background: json['section_background'] as String?,
  description: json['section_description'] as String?,
  announcement: json['section_announcement'] as String?,
  createTime: json['create_time'] as String,
  forumSection: json['forum_section'] as List<dynamic>?,
  postCount: (json['postnum'] as num).toInt(),
  viewCount: (json['viewnum'] as num).toInt(),
  commentCount: (json['commentnum'] as num).toInt(),
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
      id: (json['id'] as num).toInt(),
      name: json['section_name'] as String,
      icon: json['section_icon'] as String?,
    );

Map<String, dynamic> _$SubSectionModelToJson(SubSectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'section_name': instance.name,
      'section_icon': instance.icon,
    };
