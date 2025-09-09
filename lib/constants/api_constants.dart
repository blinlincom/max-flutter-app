/// API常量配置
class ApiConstants {
  /// 基础URL
  static const String baseUrl = 'http://api.blinlin.com/api';

  /// APP ID
  static const int appId = 1;

  /// API接口路径
  // APP相关
  static const String getAppInfo = '/get_app_info';
  static const String getAppUpdateRecords = '/get_app_update_records';
  static const String addView = '/add_view';
  static const String getAppStatisticalData = '/get_app_statistical_data';

  // 用户相关
  static const String login = '/login';
  static const String register = '/register';
  static const String mobileLogin = '/mobile_login';
  static const String getUserInformation = '/get_user_information';
  static const String getUserOtherInformation = '/get_user_other_information';
  static const String userSignIn = '/user_sign_in';
  static const String retrievePassword = '/retrieve_password';
  static const String uploadAvatar = '/upload_avatar';
  static const String uploadBackground = '/upload_background';
  static const String changePassword = '/change_password';
  static const String modifyUserInformation = '/modify_user_information';
  static const String modifyUserEmail = '/modify_user_email';
  static const String modifyUserPhone = '/modify_user_phone';
  static const String fillInvitationCode = '/fill_invitation_code';
  static const String rankingList = '/ranking_list';
  static const String invitationRanking = '/invitation_ranking';
  static const String followUsers = '/follow_users';
  static const String getFollowList = '/get_follow_list';
  static const String getFanList = '/get_fan_list';
  static const String getUserBilling = '/get_user_billing';
  static const String qqLogin = '/qq_login';
  static const String getFollowStatus = '/get_follow_status';
  static const String userWithdrawCash = '/user_withdraw_cash';
  static const String bindQq = '/bind_qq';
  static const String getUserWithdrawCashList = '/get_user_withdraw_cash_list';
  static const String qqRegister = '/qq_register';
  static const String unbindQq = '/unbind_qq';
  static const String searchUser = '/search_user';
  static const String medalWear = '/medal_wear';
  static const String getUserBadge = '/get_user_badge';
  static const String getOnlineUser = '/get_online_user';

  // 卡密相关
  static const String applyDirectChargeKm = '/apply_direct_charge_km';
  static const String applyLoginKm = '/apply_login_km';
  static const String automaticLogin = '/automatic_login';

  // 商城相关
  static const String productList = '/product_list';
  static const String getProductInformation = '/get_product_information';
  static const String buyGoods = '/buy_goods';
  static const String getOrderRecord = '/get_order_record';

  // 应用商店相关
  static const String appCategoryList = '/app_category_list';
  static const String appCategoryChildrenList = '/app_category_children_list';
  static const String getAppsList = '/get_apps_list';
  static const String getAppsInformation = '/get_apps_information';

  // 论坛相关
  static const String getSectionList = '/get_section_list';
  static const String getSectionInformation = '/get_section_information';
  static const String getPostsList = '/get_posts_list';
  static const String getRecommendedPosts = '/get_recommended_posts';

  // 验证码相关
  static const String getImageVerificationCode = '/get_image_verification_code';
  static const String getMobileVerificationCode =
      '/get_mobile_verification_code';
  static const String getEmailVerificationCode = '/get_email_verification_code';

  // 心跳和登出
  static const String userHeartbeat = '/user_heartbeat';
  static const String logOutLogin = '/log_out_login';
}
