import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/storage_utils.dart';

/// 用户状态管理
class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  String? _userToken;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  /// 当前用户
  UserModel? get currentUser => _currentUser;

  /// 用户Token
  String? get userToken => _userToken;

  /// 是否已登录
  bool get isLoggedIn => _isLoggedIn;

  /// 是否加载中
  bool get isLoading => _isLoading;

  /// 用户昵称(显示用)
  String get displayName {
    if (_currentUser?.nickname?.isNotEmpty == true) {
      return _currentUser!.nickname!;
    }
    return _currentUser?.username ?? '未知用户';
  }

  /// 用户头像
  String get userAvatar {
    return _currentUser?.avatar ?? AppConstants.defaultAvatar;
  }

  /// 初始化
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 检查本地存储的用户信息
      final token = await StorageUtils.getString(AppConstants.userTokenKey);
      final userJson = await StorageUtils.getObject(AppConstants.userInfoKey);

      if (token != null && userJson != null) {
        _userToken = token;
        _currentUser = UserModel.fromJson(userJson);
        _isLoggedIn = true;

        // 设置API服务的token
        ApiService().setUserToken(token);

        // 尝试刷新用户信息
        await _refreshUserInfo();
      }
    } catch (e) {
      debugPrint('初始化用户信息失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 登录
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().login(
        username: username,
        password: password,
      );

      if (response.isSuccess && response.data != null) {
        final loginData = response.data!;
        _userToken = loginData.userToken;
        _isLoggedIn = true;

        // 保存token
        await StorageUtils.setString(AppConstants.userTokenKey, _userToken!);
        await StorageUtils.setInt(AppConstants.userIdKey, loginData.id);
        await StorageUtils.setString(
          AppConstants.usernameKey,
          loginData.username,
        );

        // 设置API服务的token
        ApiService().setUserToken(_userToken);

        // 获取完整用户信息
        await _refreshUserInfo();

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('登录失败: $e');
      return false;
    }
  }

  /// 登出
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 调用登出API
      await ApiService().logout();
    } catch (e) {
      debugPrint('登出API调用失败: $e');
    } finally {
      // 清除本地数据
      await _clearUserData();

      _currentUser = null;
      _userToken = null;
      _isLoggedIn = false;
      _isLoading = false;

      // 清除API服务的token
      ApiService().setUserToken(null);

      notifyListeners();
    }
  }

  /// 刷新用户信息
  Future<void> refreshUserInfo() async {
    if (!_isLoggedIn) return;
    await _refreshUserInfo();
  }

  /// 更新用户信息
  void updateUserInfo(UserModel user) {
    _currentUser = user;
    // 保存到本地
    StorageUtils.setObject(AppConstants.userInfoKey, user.toJson());
    notifyListeners();
  }

  /// 私有方法：刷新用户信息
  Future<void> _refreshUserInfo() async {
    try {
      final response = await ApiService().getCurrentUserInfo();
      if (response.isSuccess && response.data != null) {
        _currentUser = response.data;
        // 保存到本地
        await StorageUtils.setObject(
          AppConstants.userInfoKey,
          _currentUser!.toJson(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('刷新用户信息失败: $e');
    }
  }

  /// 私有方法：清除用户数据
  Future<void> _clearUserData() async {
    await StorageUtils.remove(AppConstants.userTokenKey);
    await StorageUtils.remove(AppConstants.userIdKey);
    await StorageUtils.remove(AppConstants.usernameKey);
    await StorageUtils.remove(AppConstants.userInfoKey);
  }
}
