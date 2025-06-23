import 'package:flutter/cupertino.dart';
import '../widgets/custom_refresh_control.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> _items = ['项目 1', '项目 2', '项目 3', '项目 4', '项目 5'];

  Future<void> _handleRefresh() async {
    print('Explore页面开始刷新');
    // 模拟网络请求
    await Future.delayed(Duration(milliseconds: 800));

    // 模拟添加新数据
    setState(() {
      _items = ['新项目 ${DateTime.now().millisecond}', ..._items];
    });

    print('Explore页面刷新完成');
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
          // 复用相同的下拉刷新组件
          CustomRefreshControl(
            onRefresh: _handleRefresh,
            refreshTriggerPullDistance: 70.0, // 可以自定义触发距离
          ),

          // 简单的导航栏
          CupertinoSliverNavigationBar(
            largeTitle: Text('Explore'),
            backgroundColor:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                ? CupertinoColors.systemBackground.resolveFrom(context)
                : Color(0xFFEEF0F4),
          ),

          // 列表内容
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        CupertinoIcons.star_fill,
                        color: CupertinoColors.systemBlue,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _items[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '这是 ${_items[index]} 的描述信息',
                            style: TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_right,
                      color: CupertinoColors.systemGrey3,
                      size: 16,
                    ),
                  ],
                ),
              );
            }, childCount: _items.length),
          ),

          // 底部空白
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
