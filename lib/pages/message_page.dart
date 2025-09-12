import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../providers/user_provider.dart';
import 'login_page.dart';

/// 消息页面（私聊系统） - 小米风格现代化设计
class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 模拟私信数据
  final List<MessageItem> _privateMessages = [
    MessageItem(
      id: 1,
      avatar: 'https://picsum.photos/50/50?random=1',
      name: '张三',
      lastMessage: '你好，请问这个源码怎么使用？',
      time: '刚刚',
      unreadCount: 2,
      isOnline: true,
    ),
    MessageItem(
      id: 2,
      avatar: 'https://picsum.photos/50/50?random=2',
      name: '李四',
      lastMessage: '感谢分享，代码很棒！',
      time: '10分钟前',
      unreadCount: 0,
      isOnline: false,
    ),
    MessageItem(
      id: 3,
      avatar: 'https://picsum.photos/50/50?random=3',
      name: '王五',
      lastMessage: '有个问题想请教一下',
      time: '1小时前',
      unreadCount: 1,
      isOnline: true,
    ),
  ];

  // 系统通知数据
  final List<NotificationItem> _systemNotifications = [
    NotificationItem(
      id: 1,
      icon: Icons.thumb_up,
      title: '收到新的点赞',
      content: '用户"测试用户"点赞了您的帖子"Flutter开发技巧"',
      time: '5分钟前',
      isRead: false,
    ),
    NotificationItem(
      id: 2,
      icon: Icons.comment,
      title: '新的评论回复',
      content: '用户"开发者"回复了您的评论',
      time: '30分钟前',
      isRead: false,
    ),
    NotificationItem(
      id: 3,
      icon: Icons.person_add,
      title: '新的关注者',
      content: '用户"小明"关注了您',
      time: '2小时前',
      isRead: true,
    ),
    NotificationItem(
      id: 4,
      icon: Icons.star,
      title: '帖子被推荐',
      content: '您的帖子"React最佳实践"被推荐到首页',
      time: '昨天',
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isLoggedIn) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('消息'),
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.textPrimaryColor,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.message_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '登录后查看消息',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 120,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('立即登录'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('消息'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              // TODO: 搜索消息
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              // TODO: 新建私聊
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('私信'),
                  if (_getUnreadPrivateCount() > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        _getUnreadPrivateCount().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('通知'),
                  if (_getUnreadNotificationCount() > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        _getUnreadNotificationCount().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildPrivateMessagesTab(), _buildNotificationsTab()],
      ),
    );
  }

  /// 构建私信标签页
  Widget _buildPrivateMessagesTab() {
    if (_privateMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 40,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无私信消息',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _privateMessages.length,
        itemBuilder: (context, index) {
          final message = _privateMessages[index];
          return _buildMessageItem(message);
        },
      ),
    );
  }

  /// 构建通知标签页
  Widget _buildNotificationsTab() {
    return Column(
      children: [
        // 全部标记已读
        if (_getUnreadNotificationCount() > 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  for (var notification in _systemNotifications) {
                    notification.isRead = true;
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('全部标记已读'),
            ),
          ),

        // 通知列表
        Expanded(
          child: _systemNotifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.1),
                              AppTheme.primaryColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          size: 40,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '暂无系统通知',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowColor,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _systemNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _systemNotifications[index];
                      return _buildNotificationItem(notification);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  /// 构建私信项
  Widget _buildMessageItem(MessageItem message) {
    return Container(
      decoration: BoxDecoration(
        color: message.unreadCount > 0
            ? AppTheme.primaryColor.withOpacity(0.05)
            : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(message.avatar),
              backgroundColor: AppTheme.textHintColor.withOpacity(0.1),
            ),
            if (message.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppTheme.successColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                message.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              message.time,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                message.lastMessage,
                style: TextStyle(
                  color: message.unreadCount > 0
                      ? AppTheme.textPrimaryColor
                      : AppTheme.textSecondaryColor,
                  fontWeight: message.unreadCount > 0
                      ? FontWeight.w500
                      : FontWeight.normal,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (message.unreadCount > 0)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppTheme.errorColor,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  message.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        onTap: () {
          // TODO: 打开聊天详情
          debugPrint('打开与${message.name}的聊天');
        },
      ),
    );
  }

  /// 构建通知项
  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      decoration: BoxDecoration(
        color: !notification.isRead
            ? AppTheme.primaryColor.withOpacity(0.05)
            : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.15),
                AppTheme.primaryColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification.icon,
            color: AppTheme.primaryColor,
            size: 22,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: notification.isRead
                      ? AppTheme.textSecondaryColor
                      : AppTheme.textPrimaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              notification.time,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        subtitle: Text(
          notification.content,
          style: TextStyle(
            color: notification.isRead
                ? AppTheme.textSecondaryColor
                : AppTheme.textPrimaryColor,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: !notification.isRead
            ? Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppTheme.errorColor,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          setState(() {
            notification.isRead = true;
          });
          // TODO: 处理通知点击
          debugPrint('点击通知: ${notification.title}');
        },
      ),
    );
  }

  /// 获取未读私信数量
  int _getUnreadPrivateCount() {
    return _privateMessages.where((message) => message.unreadCount > 0).length;
  }

  /// 获取未读通知数量
  int _getUnreadNotificationCount() {
    return _systemNotifications
        .where((notification) => !notification.isRead)
        .length;
  }
}

/// 私信数据模型
class MessageItem {
  final int id;
  final String avatar;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  MessageItem({
    required this.id,
    required this.avatar,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}

/// 通知数据模型
class NotificationItem {
  final int id;
  final IconData icon;
  final String title;
  final String content;
  final String time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.content,
    required this.time,
    required this.isRead,
  });
}
