import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// 通用API响应模型
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final int code;
  @JsonKey(name: 'msg')
  final String message;
  final T? data;
  final int? timestamp;
  final String? sign;

  const ApiResponse({
    required this.code,
    required this.message,
    this.data,
    this.timestamp,
    this.sign,
  });

  /// 是否成功
  bool get isSuccess => code == 1;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

/// 分页响应模型
@JsonSerializable(genericArgumentFactories: true)
class PageResponse<T> {
  final List<T> list;
  @JsonKey(name: 'pagecount')
  final int pageCount;
  @JsonKey(name: 'current_number')
  final dynamic currentNumber;

  const PageResponse({
    required this.list,
    required this.pageCount,
    required this.currentNumber,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PageResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PageResponseToJson(this, toJsonT);
}
