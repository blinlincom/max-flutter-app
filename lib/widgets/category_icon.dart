import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/category_icon_manager.dart';

/// 分类图标组件
/// 支持从网络加载图标，如果网络图标不可用则显示本地默认图标
class CategoryIcon extends StatelessWidget {
  final String? networkIconUrl;
  final String? categoryName;
  final int categoryId;
  final double size;
  final Color? color;

  const CategoryIcon({
    super.key,
    this.networkIconUrl,
    this.categoryName,
    required this.categoryId,
    this.size = 28,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // 检查是否有有效的网络图标URL
    final bool hasValidNetworkIcon =
        networkIconUrl != null && networkIconUrl!.isNotEmpty;

    if (hasValidNetworkIcon) {
      return CachedNetworkImage(
        imageUrl: networkIconUrl!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholder: (context, url) => _buildLoadingIcon(),
        errorWidget: (context, url, error) => _buildDefaultIcon(),
      );
    } else {
      return _buildDefaultIcon();
    }
  }

  /// 构建加载中的图标
  Widget _buildLoadingIcon() {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: SizedBox(
          width: size * 0.6,
          height: size * 0.6,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? CategoryIconManager.getColorById(categoryId),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建默认图标
  Widget _buildDefaultIcon() {
    final iconData = CategoryIconManager.getBestMatchIcon(
      categoryName,
      categoryId,
    );
    final iconColor = color ?? CategoryIconManager.getColorById(categoryId);

    return Icon(iconData, color: iconColor, size: size);
  }
}
