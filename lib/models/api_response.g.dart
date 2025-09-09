// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  code: (json['code'] as num).toInt(),
  message: json['msg'] as String,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  timestamp: (json['timestamp'] as num?)?.toInt(),
  sign: json['sign'] as String?,
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object Function(T value) toJsonT,
) => <String, dynamic>{
  'code': instance.code,
  'msg': instance.message,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'timestamp': instance.timestamp,
  'sign': instance.sign,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

PageResponse<T> _$PageResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PageResponse<T>(
  list: (json['list'] as List<dynamic>).map(fromJsonT).toList(),
  pageCount: (json['pagecount'] as num).toInt(),
  currentNumber: json['current_number'],
);

Map<String, dynamic> _$PageResponseToJson<T>(
  PageResponse<T> instance,
  Object Function(T value) toJsonT,
) => <String, dynamic>{
  'list': instance.list.map(toJsonT).toList(),
  'pagecount': instance.pageCount,
  'current_number': instance.currentNumber,
};
