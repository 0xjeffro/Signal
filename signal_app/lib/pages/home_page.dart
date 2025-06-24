import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../widgets/custom_refresh_control.dart';

class HomePage extends StatefulWidget {
  final MyAppState appState;

  const HomePage({super.key, required this.appState});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _handleRefresh() async {
    print('开始刷新');
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 1));
    print('刷新完成');
  }

  // 生成假消息数据
  Map<String, dynamic> _generateFakeMessage(int index) {
    final List<String> titles = [
      'iOS 17 新特性发布',
      'Flutter 3.16 更新详情',
      '苹果开发者大会 WWDC 2024',
      'SwiftUI 最佳实践分享',
      'Dart 3.0 语言特性解析',
      '移动开发趋势分析',
      'Xcode 15 性能优化',
      'App Store 审核指南更新',
      'iOS 设计规范 2024',
      'Flutter Web 生产环境实践',
    ];

    final List<String> contents = [
      '苹果公司在今年的开发者大会上发布了iOS 17的重要更新，包含了全新的交互式小组件、改进的锁屏体验，以及更强大的机器学习框架。开发者现在可以利用这些新功能为用户创建更加个性化和智能的应用体验，特别是在小组件的交互性和实时数据展示方面有了显著的提升。',
      'Flutter团队发布了3.16版本的重大更新。',
      'WWDC 2024将于6月举行，预计将发布iOS 18、macOS 15等重要系统更新，以及全新的开发工具和框架。此次大会将重点关注人工智能集成、增强现实技术的进步，以及开发者工具链的全面升级。苹果还将展示新的编程语言特性和框架改进，帮助开发者构建更高效、更具创新性的应用程序。',
      '本文深入探讨了SwiftUI的最佳实践，包括状态管理、性能优化、以及如何构建可复用的UI组件。通过实际案例分析，我们将学习如何有效地组织代码结构，避免常见的性能陷阱。',
      'Dart 3.0带来了许多激动人心的新特性。',
      '移动开发领域正在经历快速变化，跨平台框架、AI集成、以及新的用户界面设计模式正在重塑行业格局。开发者需要不断学习新技术，适应用户需求的变化，同时保持代码的可维护性和应用的性能表现。未来几年，我们将看到更多基于机器学习的开发工具和自动化解决方案的出现。',
      'Xcode 15引入了多项性能优化。',
      'App Store审核指南进行了重要更新，涉及隐私保护、内容审核标准，以及新的提交流程要求。开发者需要特别注意用户数据的处理方式，确保应用符合最新的隐私规范。同时，新的审核流程将更加注重应用的质量和用户体验，要求开发者提供更详细的应用说明和测试用例。',
      '苹果发布了2024年的iOS设计规范更新。',
      'Flutter Web在生产环境中的应用越来越广泛，本文分享了性能优化、SEO优化，以及部署的最佳实践。我们将详细讨论如何解决Flutter Web应用中常见的性能问题，包括包大小优化、首屏加载时间减少，以及搜索引擎优化策略。通过这些技术手段，Flutter Web应用可以达到与原生Web应用相当的用户体验。',
    ];

    final List<String> channels = [
      'iOS开发频道',
      'Flutter社区',
      'Apple Developer',
      'SwiftUI精选',
      'Dart语言',
      '移动开发者',
      'Xcode技巧',
      'App Store指南',
      '设计规范',
      'Flutter实战',
    ];

    final List<Color> channelColors = [
      CupertinoColors.systemBlue,
      CupertinoColors.systemGreen,
      CupertinoColors.systemOrange,
      CupertinoColors.systemPurple,
      CupertinoColors.systemRed,
      CupertinoColors.systemTeal,
      CupertinoColors.systemIndigo,
      CupertinoColors.systemPink,
      CupertinoColors.systemYellow,
      CupertinoColors.systemCyan,
    ];

    // 生成时间（最近7天内的随机时间）
    final now = DateTime.now();
    final randomHours = (index * 3 + 2) % 168; // 最近7天
    final messageTime = now.subtract(Duration(hours: randomHours));

    return {
      'title': titles[index % titles.length],
      'content': contents[index % contents.length],
      'channel': channels[index % channels.length],
      'channelColor': channelColors[index % channelColors.length],
      'time': messageTime,
      'views': (index + 1) * 1234 + (index * 567),
      'maxLines': 2 + (index % 5), // 2-6行随机
    };
  }

  // 构建消息卡片
  Widget _buildMessageCard(BuildContext context, Map<String, dynamic> message) {
    return Container(
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
                  minSize: 0,
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                  onPressed: () {
                    // 点击查看详情
                  },
                ),
              ],
            ),
          ],
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

  // 构建集合选择器
  Widget _buildCollectionSelector(BuildContext context) {
    final appState = context.watch<MyAppState>();

    return Container(
      height: 32.0,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: appState.collections.length,
        onReorder: appState.reorderCollections,
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final double animValue = Curves.easeInOut.transform(
                animation.value,
              );
              final double scale = (1.0 + animValue * 0.1);
              return Transform.scale(scale: scale, child: child);
            },
            child: child,
          );
        },
        itemBuilder: (context, index) {
          final collection = appState.collections[index];
          final isSelected = collection == appState.selectedCollection;
          final isAll = collection == 'All';

          return Padding(
            key: ValueKey(collection),
            padding: EdgeInsets.only(right: 6.0),
            child: GestureDetector(
              onTap: () => appState.setSelectedCollection(collection),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? CupertinoColors.systemBlue
                      : CupertinoColors.systemGrey6.resolveFrom(context),
                  borderRadius: BorderRadius.circular(16),
                  border: isAll
                      ? null
                      : Border.all(
                          color: CupertinoColors.systemGrey4
                              .resolveFrom(context)
                              .withOpacity(0.3),
                          width: 0.5,
                        ),
                ),
                child: Center(
                  child: Text(
                    collection,
                    style: TextStyle(
                      color: isSelected
                          ? CupertinoColors.white
                          : CupertinoColors.secondaryLabel.resolveFrom(context),
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 显示添加集合对话框
  void _showAddCollectionDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final appState = context.read<MyAppState>();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('创建新集合'),
        content: Padding(
          padding: EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: controller,
            placeholder: '输入集合名称',
            autofocus: true,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('创建'),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                appState.addCollection(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  // 获取筛选后的消息列表
  List<Map<String, dynamic>> _getFilteredMessages() {
    final appState = context.watch<MyAppState>();
    final allMessages = List.generate(
      20,
      (index) => _generateFakeMessage(index),
    );

    if (appState.selectedCollection == 'All') {
      return allMessages;
    }

    // 根据集合筛选消息
    return allMessages.where((message) {
      final channel = message['channel'] as String;
      return _isChannelInCollection(channel, appState.selectedCollection);
    }).toList();
  }

  // 判断频道是否属于指定集合
  bool _isChannelInCollection(String channel, String collection) {
    switch (collection) {
      case 'iOS开发':
        return ['iOS开发频道', 'SwiftUI精选', 'Xcode技巧'].contains(channel);
      case 'Flutter':
        return ['Flutter社区', 'Flutter实战', 'Dart语言'].contains(channel);
      case 'Apple':
        return ['Apple Developer', 'iOS开发频道', 'SwiftUI精选'].contains(channel);
      case '设计规范':
        return ['设计规范', 'iOS开发频道'].contains(channel);
      case '工具技巧':
        return ['Xcode技巧', 'App Store指南', '移动开发者'].contains(channel);
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
          ? CupertinoColors.systemBackground.resolveFrom(context)
          : Color(0xFFEEF0F4),
      child: CustomScrollView(
        slivers: [
          // 使用自定义的下拉刷新组件
          CustomRefreshControl(onRefresh: _handleRefresh),

          // iOS风格的Collapsing Navigation Bar
          CupertinoSliverNavigationBar(
            largeTitle: Text('Inbox'),
            backgroundColor:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                ? CupertinoColors.systemBackground.resolveFrom(context)
                : Color(0xFFEEF0F4),
          ),

          // 集合标签选择器 - 吸顶效果
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              minHeight: 48.0,
              maxHeight: 48.0,
              child: Container(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? CupertinoColors.systemBackground.resolveFrom(context)
                    : Color(0xFFEEF0F4),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      // 集合标签选择器
                      Expanded(child: _buildCollectionSelector(context)),
                      SizedBox(width: 12),
                      // 添加集合按钮
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6.resolveFrom(
                            context,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _showAddCollectionDialog(context),
                          child: Icon(
                            CupertinoIcons.add,
                            color: CupertinoColors.systemGrey,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 消息卡片列表
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final filteredMessages = _getFilteredMessages();
              if (index >= filteredMessages.length) return null;
              final message = filteredMessages[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildMessageCard(context, message),
              );
            }, childCount: _getFilteredMessages().length),
          ),

          // 底部间距，避免被bottom sheet遮挡
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// Sticky Header的委托类
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
