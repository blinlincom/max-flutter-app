import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/post_model.dart';

/// 板块头部组件
class SectionHeader extends StatelessWidget {
  final SectionModel section;
  final VoidCallback? onTap;

  const SectionHeader({super.key, required this.section, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 板块图标
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSectionIcon(section.name),
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              // 板块信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 板块名称
                    Text(
                      section.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // 板块描述
                    if (section.description?.isNotEmpty ?? false)
                      Text(
                        section.description!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // 统计信息
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 帖子数
                  Text(
                    '${section.postCount}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const Text(
                    '帖子',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              // 箭头图标
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 根据板块名称获取图标
  IconData _getSectionIcon(String sectionName) {
    switch (sectionName) {
      case '技术讨论':
        return Icons.code;
      case '源码分享':
        return Icons.share;
      case '求助问答':
        return Icons.help_outline;
      case '项目展示':
        return Icons.apps;
      case '招聘求职':
        return Icons.work_outline;
      case '闲聊灌水':
        return Icons.chat_bubble_outline;
      default:
        return Icons.forum;
    }
  }
}
