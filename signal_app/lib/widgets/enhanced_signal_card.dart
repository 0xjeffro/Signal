import 'package:flutter/cupertino.dart';

// 信号更新数据结构 - 完全灵活，由信号开发者定义
class SignalUpdate {
  final String title; // 更新标题，如"加仓"、"止盈"、"新消息"等
  final String? description; // 更新描述
  final DateTime time; // 更新时间
  final Color? color; // 可选的颜色标识
  final IconData? icon; // 可选的图标
  final Map<String, dynamic>? data; // 额外数据，完全由开发者定义

  SignalUpdate({
    required this.title,
    this.description,
    required this.time,
    this.color,
    this.icon,
    this.data,
  });
}

class EnhancedSignalCard extends StatefulWidget {
  final Map<String, dynamic> signal;
  final VoidCallback? onTap;

  const EnhancedSignalCard({super.key, required this.signal, this.onTap});

  @override
  State<EnhancedSignalCard> createState() => _EnhancedSignalCardState();
}

class _EnhancedSignalCardState extends State<EnhancedSignalCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();

    // 初始化呼吸灯动画控制器
    _breathingController = AnimationController(
      duration: Duration(milliseconds: 1500), // 1.5秒一个呼吸周期，稍快一点
      vsync: this,
    );

    // 创建呼吸灯动画（透明度在0.4-1.0之间变化，效果更明显）
    _breathingAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut, // 自然的呼吸节奏
      ),
    );

    // 开始无限循环的呼吸动画
    _breathingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signal = widget.signal;
    final List<SignalUpdate> updates = _parseUpdates(signal['updates'] ?? []);
    final bool hasUpdates = updates.isNotEmpty;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? CupertinoColors.systemGrey6.resolveFrom(context)
              : CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(signal, context),
            width: hasUpdates ? 1.0 : 0.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部：频道/来源 + 时间 + 状态指示器
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          (signal['channelColor'] as Color? ??
                                  CupertinoColors.systemBlue)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (signal['channelIcon'] != null) ...[
                          Icon(
                            signal['channelIcon'] as IconData,
                            size: 12,
                            color:
                                signal['channelColor'] as Color? ??
                                CupertinoColors.systemBlue,
                          ),
                          SizedBox(width: 4),
                        ],
                        Text(
                          signal['channel'] ?? 'Signal',
                          style: TextStyle(
                            color:
                                signal['channelColor'] as Color? ??
                                CupertinoColors.systemBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  if (hasUpdates) ...[
                    _buildStatusIndicator(),
                    SizedBox(width: 8),
                  ],
                  Text(
                    _formatTime(signal['time'] as DateTime),
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // 1. 大标题（必有）
              Text(
                signal['title'] ?? 'Signal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),

              // 2. 副标题（可选）
              if (signal['subtitle'] != null) ...[
                SizedBox(height: 4),
                Text(
                  signal['subtitle'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                ),
              ],

              SizedBox(height: 8),

              // 3. 正文内容区域（至少要有描述或数据列表之一）
              _buildContentSection(signal),

              // Follow-up 更新部分
              if (hasUpdates) ...[
                SizedBox(height: 4),
                _buildFollowUpSection(updates),
                SizedBox(height: 8),
              ],

              // 底部操作栏
              _buildBottomActions(signal, hasUpdates),
            ],
          ),
        ),
      ),
    );
  }

  // 解析更新数据，支持灵活的数据结构
  List<SignalUpdate> _parseUpdates(List<dynamic> updatesData) {
    return updatesData.map<SignalUpdate>((data) {
      if (data is SignalUpdate) {
        return data;
      } else if (data is Map<String, dynamic>) {
        return SignalUpdate(
          title: data['title'] ?? 'Update',
          description: data['description'],
          time: data['time'] ?? DateTime.now(),
          color: data['color'],
          icon: data['icon'],
          data: data['data'],
        );
      } else {
        return SignalUpdate(title: data.toString(), time: DateTime.now());
      }
    }).toList();
  }

  // 构建正文内容区域（产品优化：描述和数据列表至少有一个）
  Widget _buildContentSection(Map<String, dynamic> signal) {
    final hasContent =
        signal['content'] != null && signal['content'].toString().isNotEmpty;
    final hasCustomData =
        signal['customData'] != null &&
        (signal['customData'] as Map).isNotEmpty;

    // 至少要有描述或数据列表之一
    if (!hasContent && !hasCustomData) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 3. 正文描述（可选，但与数据列表至少有一个）
        if (hasContent) ...[
          Text(
            signal['content'],
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              height: 1.4,
            ),
            maxLines: signal['maxLines'] ?? 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (hasCustomData) SizedBox(height: 12), // 如果还有数据列表，加个间距
        ],

        // 4. 正文数据列表（可选，但与描述至少有一个）
        if (hasCustomData) ...[_buildCustomDataSection(signal['customData'])],

        SizedBox(height: 8),
      ],
    );
  }

  // 构建自定义数据展示区域
  Widget _buildCustomDataSection(Map<String, dynamic> customData) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: customData.entries.map((entry) {
        return _buildDataItem(entry.key, entry.value);
      }).toList(),
    );
  }

  // 构建单个数据项
  Widget _buildDataItem(String label, dynamic value) {
    String displayValue = '';
    Color? valueColor;

    if (value is num) {
      if (label.toLowerCase().contains('price') ||
          label.toLowerCase().contains('entry')) {
        displayValue = '\$${value.toStringAsFixed(2)}';
      } else if (label.toLowerCase().contains('amount') ||
          label.toLowerCase().contains('size')) {
        displayValue = '\$${_formatAmount(value.toDouble())}';
      } else if (label.toLowerCase().contains('leverage')) {
        displayValue = '${value.toStringAsFixed(0)}x';
        valueColor = CupertinoColors.systemOrange;
      } else {
        displayValue = value.toString();
      }
    } else if (value is String) {
      displayValue = value;
      // 检查是否是方向标识
      if (value.toUpperCase() == 'LONG') {
        valueColor = CupertinoColors.systemGreen;
      } else if (value.toUpperCase() == 'SHORT') {
        valueColor = CupertinoColors.systemRed;
      }
    } else {
      displayValue = value.toString();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
        Text(
          displayValue,
          style: TextStyle(
            fontSize: 14,
            color: valueColor ?? CupertinoColors.label.resolveFrom(context),
            fontWeight: valueColor != null
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // 构建Follow-up更新部分
  Widget _buildFollowUpSection(List<SignalUpdate> updates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Follow-up标题和展开按钮
        Row(
          children: [
            Text(
              'Follow-up Updates',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
            Expanded(child: SizedBox()), // 使用Expanded让间距更均匀
            if (updates.length > 2)
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                ), // 给Show All/Show Less左侧加一点间距
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? 'Show Less' : 'Show All',
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemBlue,
                        ),
                      ),
                      SizedBox(width: 4), // 在文字和箭头间加一点间距
                      Icon(
                        _isExpanded
                            ? CupertinoIcons.chevron_up
                            : CupertinoIcons.chevron_down,
                        size: 12,
                        color: CupertinoColors.systemBlue,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8),

        // 更新列表
        ...(_isExpanded ? updates : updates.take(2)).map(
          (update) => _buildUpdateItem(update),
        ),
      ],
    );
  }

  // 构建单个更新项
  Widget _buildUpdateItem(SignalUpdate update) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? CupertinoColors.systemGrey5.resolveFrom(context).withOpacity(0.3)
            : CupertinoColors.systemGrey6.resolveFrom(context).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // 更新图标
          if (update.icon != null) ...[
            Icon(
              update.icon!,
              size: 16,
              color: update.color ?? CupertinoColors.systemBlue,
            ),
            SizedBox(width: 8),
          ],

          // 更新内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  update.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                if (update.description != null) ...[
                  SizedBox(height: 2),
                  Text(
                    update.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel.resolveFrom(
                        context,
                      ),
                    ),
                  ),
                ],
                // 显示额外数据
                if (update.data != null) ...[
                  SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: update.data!.entries.map((entry) {
                      return Text(
                        '${entry.key}: ${entry.value}',
                        style: TextStyle(
                          fontSize: 11,
                          color: CupertinoColors.tertiaryLabel.resolveFrom(
                            context,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),

          // 时间
          Text(
            _formatTime(update.time),
            style: TextStyle(
              fontSize: 11,
              color: CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }

  // 构建底部操作栏
  Widget _buildBottomActions(Map<String, dynamic> signal, bool hasUpdates) {
    return Row(
      children: [
        Icon(CupertinoIcons.eye, size: 14, color: CupertinoColors.systemGrey),
        SizedBox(width: 4),
        Text(
          '${signal['views'] ?? signal['followers'] ?? 0} ${signal['views'] != null ? 'views' : 'followers'}',
          style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
        ),
        if (hasUpdates) ...[
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${(signal['updates'] as List? ?? []).length} updates',
              style: TextStyle(
                fontSize: 11,
                color: CupertinoColors.systemBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        Expanded(child: SizedBox()), // 使用Expanded代替Spacer，更可控
        // 在右侧箭头前加一点额外间距，让布局更舒适
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: widget.onTap,
            child: Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
      ],
    );
  }

  // 获取状态指示器（呼吸灯效果）
  Widget _buildStatusIndicator() {
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGreen.withOpacity(
              _breathingAnimation.value,
            ),
            shape: BoxShape.circle,
            // 添加呼吸灯的发光效果
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGreen.withOpacity(
                  _breathingAnimation.value * 0.4,
                ),
                blurRadius: 4,
                spreadRadius: 0.5,
              ),
              // 添加内部高光，让呼吸效果更立体
              BoxShadow(
                color: CupertinoColors.systemGreen.withOpacity(
                  _breathingAnimation.value * 0.2,
                ),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }

  // 获取边框颜色
  Color _getBorderColor(Map<String, dynamic> signal, BuildContext context) {
    // 如果有更新，使用蓝色边框突出显示
    if (signal['updates'] != null && (signal['updates'] as List).isNotEmpty) {
      return CupertinoColors.systemBlue.withOpacity(0.3);
    }

    // 如果指定了状态颜色，使用状态颜色
    if (signal['statusColor'] != null) {
      return (signal['statusColor'] as Color).withOpacity(0.3);
    }

    // 默认边框
    return CupertinoColors.systemGrey5.resolveFrom(context).withOpacity(0.3);
  }

  // 格式化金额
  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  // 格式化时间显示
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${time.month}/${time.day}';
    }
  }
}
