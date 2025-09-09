import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'post_model.g.dart';

/// 帖子模型
@JsonSerializable()
class PostModel {
  @JsonKey(name: 'postid')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'content')
  final String content;

  @JsonKey(name: 'userid')
  final int userId;

  @JsonKey(name: 'create_time')
  final String createTime;

  @JsonKey(name: 'update_time')
  final String updateTime;

  @JsonKey(name: 'status')
  final int status;

  @JsonKey(name: 'appid')
  final int appId;

  @JsonKey(name: 'section_id')
  final int sectionId;

  @JsonKey(name: 'sub_section_id')
  final int subSectionId;

  @JsonKey(name: 'sticky')
  final int sticky;

  @JsonKey(name: 'popular')
  final int popular;

  @JsonKey(name: 'featured')
  final int featured;

  @JsonKey(name: 'video_url')
  final String? videoUrl;

  @JsonKey(name: 'img_url')
  final List<String>? imageUrls;

  @JsonKey(name: 'score')
  final String score;

  @JsonKey(name: 'paid_reading')
  final int paidReading;

  @JsonKey(name: 'file_download_method')
  final int fileDownloadMethod;

  @JsonKey(name: 'video_img')
  final String? videoImage;

  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'nickname')
  final String nickname;

  @JsonKey(name: 'usertx')
  final String avatar;

  @JsonKey(name: 'usertitle')
  final List<String>? userTitles;

  @JsonKey(name: 'sex')
  final int sex;

  @JsonKey(name: 'signature')
  final String signature;

  @JsonKey(name: 'exp')
  final int exp;

  @JsonKey(name: 'section_name')
  final String sectionName;

  @JsonKey(name: 'section_icon')
  final String? sectionIcon;

  @JsonKey(name: 'sub_section_name')
  final String subSectionName;

  @JsonKey(name: 'ip_address')
  final String ipAddress;

  @JsonKey(name: 'sexName')
  final String sexName;

  @JsonKey(name: 'is_section_moderator')
  final int isSectionModerator;

  @JsonKey(name: 'badge')
  final List<BadgeModel>? badges;

  @JsonKey(name: 'vip')
  final bool isVip;

  @JsonKey(name: 'hierarchy')
  final String hierarchy;

  @JsonKey(name: 'create_time_ago')
  final String createTimeAgo;

  @JsonKey(name: 'update_time_ago')
  final String updateTimeAgo;

  @JsonKey(name: 'view')
  final int viewCount;

  @JsonKey(name: 'thumbs')
  final int thumbsCount;

  @JsonKey(name: 'comment')
  final int commentCount;

  @JsonKey(name: 'reward')
  final int rewardCount;

  @JsonKey(name: 'payers')
  final int payersCount;

  const PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.createTime,
    required this.updateTime,
    required this.status,
    required this.appId,
    required this.sectionId,
    required this.subSectionId,
    required this.sticky,
    required this.popular,
    required this.featured,
    this.videoUrl,
    this.imageUrls,
    required this.score,
    required this.paidReading,
    required this.fileDownloadMethod,
    this.videoImage,
    required this.username,
    required this.nickname,
    required this.avatar,
    this.userTitles,
    required this.sex,
    required this.signature,
    required this.exp,
    required this.sectionName,
    this.sectionIcon,
    required this.subSectionName,
    required this.ipAddress,
    required this.sexName,
    required this.isSectionModerator,
    this.badges,
    required this.isVip,
    required this.hierarchy,
    required this.createTimeAgo,
    required this.updateTimeAgo,
    required this.viewCount,
    required this.thumbsCount,
    required this.commentCount,
    required this.rewardCount,
    required this.payersCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}

/// 板块模型
@JsonSerializable()
class SectionModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'section_name')
  final String name;

  @JsonKey(name: 'section_icon')
  final String? icon;

  @JsonKey(name: 'section_background')
  final String? background;

  @JsonKey(name: 'section_description')
  final String? description;

  @JsonKey(name: 'section_announcement')
  final String? announcement;

  @JsonKey(name: 'create_time')
  final String createTime;

  @JsonKey(name: 'forum_section')
  final List<dynamic>? forumSection;

  @JsonKey(name: 'postnum')
  final int postCount;

  @JsonKey(name: 'viewnum')
  final int viewCount;

  @JsonKey(name: 'commentnum')
  final int commentCount;

  @JsonKey(name: 'sub_section')
  final List<SubSectionModel>? subSections;

  const SectionModel({
    required this.id,
    required this.name,
    this.icon,
    this.background,
    this.description,
    this.announcement,
    required this.createTime,
    this.forumSection,
    required this.postCount,
    required this.viewCount,
    required this.commentCount,
    this.subSections,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) =>
      _$SectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionModelToJson(this);
}

/// 子板块模型
@JsonSerializable()
class SubSectionModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'section_name')
  final String name;

  @JsonKey(name: 'section_icon')
  final String? icon;

  const SubSectionModel({required this.id, required this.name, this.icon});

  factory SubSectionModel.fromJson(Map<String, dynamic> json) =>
      _$SubSectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubSectionModelToJson(this);
}
