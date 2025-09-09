import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../utils/storage_utils.dart';

/// API服务类
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _userToken;

  /// 初始化
  Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConstants.networkTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.networkTimeout,
        ),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
    );

    // 添加请求拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 添加公共参数
          if (options.data is Map) {
            options.data['appid'] = ApiConstants.appId;
            options.data['timestamp'] =
                DateTime.now().millisecondsSinceEpoch ~/ 1000;

            // 添加用户token
            if (_userToken != null) {
              options.data['usertoken'] = _userToken;
            }
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );

    // 获取保存的用户token
    _userToken = await StorageUtils.getString(AppConstants.userTokenKey);
  }

  /// 设置用户token
  void setUserToken(String? token) {
    _userToken = token;
  }

  /// 获取设备ID
  Future<String> _getDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? const Uuid().v4();
      } else {
        return const Uuid().v4();
      }
    } catch (e) {
      return const Uuid().v4();
    }
  }

  /// 通用POST请求
  Future<ApiResponse<T>> _post<T>(
    String path,
    Map<String, dynamic> data, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final apiResponse = ApiResponse<T>.fromJson(
        response.data,
        fromJson ?? (json) => json as T,
      );

      return apiResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException('请求失败: $e');
    }
  }

  /// 用户登录
  Future<ApiResponse<LoginResponse>> login({
    required String username,
    required String password,
    String? captcha,
  }) async {
    final deviceId = await _getDeviceId();

    return _post<LoginResponse>(
      ApiConstants.login,
      {
        'username': username,
        'password': password,
        if (captcha != null) 'captcha': captcha,
        'device': deviceId,
      },
      fromJson: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 用户注册
  Future<ApiResponse<dynamic>> register({
    required String username,
    required String password,
    String? mobile,
    String? email,
    String? captcha,
    String? inviteCode,
  }) async {
    final deviceId = await _getDeviceId();

    return _post<dynamic>(ApiConstants.register, {
      'username': username,
      'password': password,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (captcha != null) 'captcha': captcha,
      if (inviteCode != null) 'invitecode': inviteCode,
      'device': deviceId,
    });
  }

  /// 获取用户信息
  Future<ApiResponse<UserModel>> getUserInfo(int userId) async {
    return _post<UserModel>(
      ApiConstants.getUserInformation,
      {'userid': userId},
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 获取当前用户完整信息
  Future<ApiResponse<UserModel>> getCurrentUserInfo() async {
    return _post<UserModel>(
      ApiConstants.getUserOtherInformation,
      {},
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 获取板块列表
  Future<ApiResponse<PageResponse<SectionModel>>> getSectionList({
    int page = 1,
    int limit = AppConstants.pageSize,
  }) async {
    return _post<PageResponse<SectionModel>>(
      ApiConstants.getSectionList,
      {'page': page, 'limit': limit},
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return PageResponse<SectionModel>(
          list: (data['list'] as List)
              .map(
                (item) => SectionModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
          pageCount: data['pagecount'] ?? 0,
          currentNumber: data['current_number'] ?? 1,
        );
      },
    );
  }

  /// 获取帖子列表
  Future<ApiResponse<PageResponse<PostModel>>> getPostsList({
    int? userId,
    int? sectionId,
    int? subSectionId,
    int? sticky,
    int? popular,
    int? featured,
    int? status,
    String? keyword,
    String? sort,
    String? sortOrder,
    int page = 1,
    int limit = AppConstants.pageSize,
  }) async {
    return _post<PageResponse<PostModel>>(
      ApiConstants.getPostsList,
      {
        if (userId != null) 'userid': userId,
        if (sectionId != null) 'sectionid': sectionId,
        if (subSectionId != null) 'sub_sectionid': subSectionId,
        if (sticky != null) 'sticky': sticky,
        if (popular != null) 'popular': popular,
        if (featured != null) 'featured': featured,
        if (status != null) 'status': status,
        if (keyword != null) 'keyword': keyword,
        if (sort != null) 'sort': sort,
        if (sortOrder != null) 'sortOrder': sortOrder,
        'page': page,
        'limit': limit,
      },
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return PageResponse<PostModel>(
          list: (data['list'] as List)
              .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
              .toList(),
          pageCount: data['pagecount'] ?? 0,
          currentNumber: data['current_number'] ?? 1,
        );
      },
    );
  }

  /// 获取推荐帖子
  Future<ApiResponse<PageResponse<PostModel>>> getRecommendedPosts({
    int page = 1,
    int limit = AppConstants.pageSize,
  }) async {
    return _post<PageResponse<PostModel>>(
      ApiConstants.getRecommendedPosts,
      {'page': page, 'limit': limit},
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return PageResponse<PostModel>(
          list: (data['list'] as List)
              .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
              .toList(),
          pageCount: data['pagecount'] ?? 0,
          currentNumber: data['current_number'] ?? 1,
        );
      },
    );
  }

  /// 用户签到
  Future<ApiResponse<dynamic>> userSignIn() async {
    return _post<dynamic>(ApiConstants.userSignIn, {});
  }

  /// 获取APP信息
  Future<ApiResponse<dynamic>> getAppInfo() async {
    return _post<dynamic>(ApiConstants.getAppInfo, {});
  }

  /// 增加APP访问量
  Future<ApiResponse<dynamic>> addView() async {
    return _post<dynamic>(ApiConstants.addView, {});
  }

  /// 退出登录
  Future<ApiResponse<dynamic>> logout() async {
    return _post<dynamic>(ApiConstants.logOutLogin, {});
  }
}

/// API异常类
class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException(this.message, [this.code]);

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException('连接超时');
      case DioExceptionType.sendTimeout:
        return ApiException('请求超时');
      case DioExceptionType.receiveTimeout:
        return ApiException('响应超时');
      case DioExceptionType.badResponse:
        return ApiException(
          '服务器错误: ${error.response?.statusCode}',
          error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return ApiException('请求已取消');
      case DioExceptionType.unknown:
        return ApiException('网络错误');
      default:
        return ApiException('未知错误');
    }
  }

  @override
  String toString() => message;
}
