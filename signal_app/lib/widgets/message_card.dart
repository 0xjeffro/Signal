import 'package:flutter/cupertino.dart';

class MessageCard extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback? onTap;

  const MessageCard({super.key, required this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? CupertinoColors.systemGrey6.resolveFrom(context)
              : CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CupertinoColors.systemGrey5
                .resolveFrom(context)
                .withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 频道名称和时间
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: message['channelColor'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message['channel'],
                      style: TextStyle(
                        color: message['channelColor'],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    _formatTime(message['time']),
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // 标题
              Text(
                message['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),
              SizedBox(height: 8),

              // 内容
              Text(
                message['content'],
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  height: 1.4,
                ),
                maxLines: message['maxLines'],
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),

              // 底部信息
              Row(
                children: [
                  Icon(
                    CupertinoIcons.eye,
                    size: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${_formatViews(message['views'])} 次观看',
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: onTap,
                    child: Icon(
                      CupertinoIcons.chevron_right,
                      size: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 格式化时间显示
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${time.month}月${time.day}日';
    }
  }

  // 格式化观看次数
  String _formatViews(int views) {
    if (views < 1000) {
      return views.toString();
    } else if (views < 1000000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    }
  }
}
