// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCategoryModel _$AppCategoryModelFromJson(Map<String, dynamic> json) =>
    AppCategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String?,
      createTime: json['create_time'] as String,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => AppSubCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppCategoryModelToJson(AppCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'create_time': instance.createTime,
      'children': instance.children,
    };

AppSubCategoryModel _$AppSubCategoryModelFromJson(Map<String, dynamic> json) =>
    AppSubCategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String?,
      createTime: json['create_time'] as String,
    );

Map<String, dynamic> _$AppSubCategoryModelToJson(
  AppSubCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'create_time': instance.createTime,
};
