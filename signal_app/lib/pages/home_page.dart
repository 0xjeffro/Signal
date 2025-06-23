import 'package:flutter/cupertino.dart';
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

          // Sticky Row - 吸顶效果
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              minHeight: 60.0,
              maxHeight: 60.0,
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
                  SizedBox(height: 100),
                  // 添加一些明显的背景内容来测试毛玻璃效果
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CupertinoColors.systemBlue,
                          CupertinoColors.systemPurple,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '测试毛玻璃效果\n这些内容应该在底部sheet后面模糊显示',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
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
