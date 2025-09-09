import 'package:json_annotation/json_annotation.dart';

part 'app_category_model.g.dart';

/// 应用分类模型
@JsonSerializable()
class AppCategoryModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'icon')
  final String? icon;

  @JsonKey(name: 'create_time')
  final String createTime;

  @JsonKey(name: 'children')
  final List<AppSubCategoryModel>? children;

  const AppCategoryModel({
    required this.id,
    required this.name,
    this.icon,
    required this.createTime,
    this.children,
  });

  /// 判断是否有有效图标
  bool get hasValidIcon => icon != null && icon!.isNotEmpty;

  factory AppCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$AppCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppCategoryModelToJson(this);
}

/// 应用子分类模型
@JsonSerializable()
class AppSubCategoryModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'icon')
  final String? icon;

  @JsonKey(name: 'create_time')
  final String createTime;

  const AppSubCategoryModel({
    required this.id,
    required this.name,
    this.icon,
    required this.createTime,
  });

  /// 判断是否有有效图标
  bool get hasValidIcon => icon != null && icon!.isNotEmpty;

  factory AppSubCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$AppSubCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppSubCategoryModelToJson(this);
}
