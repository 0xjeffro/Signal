import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  final MyAppState appState;

  const HomePage({super.key, required this.appState});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _isRefreshing = false;
  bool _hasTriggeredHaptic = false;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    print('开始刷新');
    setState(() {
      _isRefreshing = true;
      _hasTriggeredHaptic = false;
    });

    await Future.delayed(Duration(seconds: 2));

    print('刷新完成');
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          // iOS风格的下拉刷新
          CupertinoSliverRefreshControl(
            onRefresh: _handleRefresh,
            refreshTriggerPullDistance: 60.0,
            refreshIndicatorExtent: 60.0,
            builder:
                (
                  context,
                  refreshState,
                  pulledExtent,
                  refreshTriggerPullDistance,
                  refreshIndicatorExtent,
                ) {
                  final topPadding = MediaQuery.of(context).padding.top;

                  // 当达到触发距离时提供触感反馈
                  if (refreshState == RefreshIndicatorMode.armed &&
                      !_isRefreshing &&
                      !_hasTriggeredHaptic) {
                    _hasTriggeredHaptic = true;
                    HapticFeedback.mediumImpact();
                    _bounceController.forward().then((_) {
                      _bounceController.reverse();
                    });
                  }

                  // 重置状态
                  if (refreshState == RefreshIndicatorMode.inactive) {
                    _hasTriggeredHaptic = false;
                    _bounceController.reset();
                  }

                  Widget indicator;

                  if (refreshState == RefreshIndicatorMode.refresh ||
                      _isRefreshing) {
                    // 刷新状态：显示标准的加载动画
                    indicator = CupertinoActivityIndicator(radius: 12.0);
                  } else {
                    // 下拉状态：只显示向下箭头
                    double pullProgress =
                        (pulledExtent / refreshTriggerPullDistance).clamp(
                          0.0,
                          1.0,
                        );
                    bool isArmed = refreshState == RefreshIndicatorMode.armed;

                    // 计算动画属性
                    double iconOpacity = (pullProgress * 1.5).clamp(0.0, 1.0);
                    double iconSize = 18.0 + pullProgress * 6.0;
                    Color iconColor = isArmed
                        ? CupertinoColors.activeBlue
                        : CupertinoColors.systemGrey2.withOpacity(0.8);

                    indicator = AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        double scale = isArmed
                            ? _bounceAnimation.value
                            : (0.7 + pullProgress * 0.3);

                        return Transform.scale(
                          scale: scale,
                          child: AnimatedOpacity(
                            opacity: iconOpacity,
                            duration: Duration(milliseconds: 100),
                            child: Icon(
                              CupertinoIcons.chevron_down,
                              size: iconSize,
                              color: iconColor,
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: topPadding + 30.0,
                        bottom: 8.0,
                      ),
                      child: indicator,
                    ),
                  );
                },
          ),

          // iOS风格的Collapsing Navigation Bar
          CupertinoSliverNavigationBar(
            largeTitle: Text('Inbox'),
            backgroundColor: CupertinoColors.systemBackground,
          ),

          // Sticky Row - 吸顶效果
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              minHeight: 60.0,
              maxHeight: 60.0,
              child: Container(
                color: CupertinoColors.systemBackground,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      // 搜索框占位
                      Expanded(
                        child: Container(
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              '搜索...',
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // 其他按钮占位
                      Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          CupertinoIcons.add,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 页面内容
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Inbox页面内容\n下拉刷新试试看',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                  // 添加更多内容来测试滚动效果
                  SizedBox(height: 400),
                  Text('滚动查看iOS原生Collapsing效果', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 400),
                  Text('继续滚动...', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 200),
                ],
              ),
            ),
          ),
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
