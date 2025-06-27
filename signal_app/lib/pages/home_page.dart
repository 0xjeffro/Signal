import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../widgets/custom_refresh_control.dart';
import '../widgets/enhanced_signal_card.dart';

class HomePage extends StatefulWidget {
  final MyAppState appState;

  const HomePage({super.key, required this.appState});

  @override
  State<HomePage> createState() => _HomePageState();

  // 静态方法，用于从外部触发滚动到顶部并刷新
  static void scrollToTopAndRefresh() {
    final homePageState = homePageKey.currentState;
    if (homePageState is _HomePageState) {
      homePageState.scrollToTopAndRefresh();
    }
  }
}

// 全局键，用于从外部调用HomePage的方法
final GlobalKey<State<HomePage>> homePageKey = GlobalKey<State<HomePage>>();

class _HomePageState extends State<HomePage> {
  // 分页相关状态
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  List<Map<String, dynamic>> _allMessages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 初始化数据加载
  void _loadInitialData() {
    _allMessages = List.generate(
      _pageSize,
      (index) => _generateFlexibleSignal(index),
    );
    _currentPage = 1;
    _hasMoreData = true;
  }

  // 监听滚动事件
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 距离底部200像素时开始加载
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreData();
      }
    }
  }

  // 加载更多数据
  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    print('开始加载第${_currentPage + 1}页数据');

    // 模拟网络请求延迟
    await Future.delayed(Duration(seconds: 1));

    // 生成新的消息数据
    final newMessages = List.generate(
      _pageSize,
      (index) => _generateFlexibleSignal(_allMessages.length + index),
    );

    setState(() {
      _allMessages.addAll(newMessages);
      _currentPage++;
      _isLoadingMore = false;

      // 模拟数据有限，加载到第5页就没有更多数据了
      if (_currentPage >= 5) {
        _hasMoreData = false;
      }
    });

    print('第${_currentPage}页数据加载完成，当前共${_allMessages.length}条消息');
  }

  Future<void> _handleRefresh() async {
    print('开始刷新');
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 1));

    // 重置分页状态并重新加载
    setState(() {
      _currentPage = 1;
      _hasMoreData = true;
      _isLoadingMore = false;
      _loadInitialData();
    });

    print('刷新完成');
  }

  // 返回顶部并刷新的公开方法
  Future<void> scrollToTopAndRefresh() async {
    // 先滚动到顶部
    await _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );

    // 延迟一点时间让滚动动画完成，然后触发刷新
    await Future.delayed(Duration(milliseconds: 100));
    await _handleRefresh();
  }

  // 生成灵活的信号数据（巨鲸交易、KOL喊单、新闻等）
  Map<String, dynamic> _generateFlexibleSignal(int index) {
    final now = DateTime.now();
    // 修改时间生成逻辑：让前几个信号是最近的，后面的逐渐变老
    // 前10个信号在过去2小时内，这样能看到未读徽章
    final randomMinutes = index < 10
        ? (index * 10 + 5) %
              120 // 前10个信号：5-115分钟前
        : (index * 2 + 1) * 60 % (48 * 60); // 后面的信号：更早的时间
    final signalTime = now.subtract(Duration(minutes: randomMinutes));

    // 30% 巨鲸交易信号
    if (index % 10 < 3) {
      return _generateWhaleSignal(index, signalTime);
    }
    // 25% KOL喊单信号
    else if (index % 10 < 5) {
      return _generateKOLSignal(index, signalTime);
    }
    // 25% 链上DCA信号
    else if (index % 10 < 7) {
      return _generateDCASignal(index, signalTime);
    }
    // 20% 新闻/分析信号
    else {
      return _generateNewsSignal(index, signalTime);
    }
  }

  // 生成巨鲸交易信号
  Map<String, dynamic> _generateWhaleSignal(int index, DateTime time) {
    final whales = ['0x7f...a9e2', '0x1a...b8c4', '0x2d...f3a1'];
    final pairs = ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'];
    final sides = ['LONG', 'SHORT'];

    final signal = {
      'channel': whales[index % whales.length],
      'channelColor': CupertinoColors.systemBlue,
      'channelIcon': CupertinoIcons.graph_circle_fill,
      // 1. 大标题（必有）
      'title': pairs[index % pairs.length],
      // 2. 副标题（可选）
      'subtitle': '${sides[index % sides.length]} Position',
      // 3. 正文描述（这里省略，主要靠数据列表展示）
      // 4. 正文数据列表（可选，但与描述至少有一个）
      'customData': {
        'Entry':
            '\$${(45000.0 + (index * 1234.56) % 20000).toStringAsFixed(2)}',
        'Size': '\$${_formatAmount(100000.0 + (index * 50000))}',
        'Leverage': '${(3.0 + (index % 7)).toStringAsFixed(0)}x',
        'Side': sides[index % sides.length],
      },
      'time': time,
      'followers': 156 + (index * 23),
      'updates': <Map<String, dynamic>>[],
    };

    // 添加follow-up更新 - 增加更多更新以测试折叠/展开功能
    if (index % 3 == 0) {
      final updates = <Map<String, dynamic>>[];

      // 第一个更新：开仓
      updates.add({
        'title': 'Position Opened',
        'description': 'Initial position established',
        'time': time.add(Duration(minutes: 30)),
        'icon': CupertinoIcons.add_circled,
        'color': CupertinoColors.systemBlue,
        'data': {'Entry': '\$45,120', 'Size': '\$100K'},
      });

      // 第二个更新：加仓（如果满足条件）
      if (index % 5 == 0) {
        updates.add({
          'title': 'Position Added',
          'description': 'Increased position size',
          'time': time.add(Duration(hours: 2)),
          'icon': CupertinoIcons.plus_circle,
          'color': CupertinoColors.systemGreen,
          'data': {'Amount': '\$25K', 'Price': '\$46,200'},
        });
      }

      // 第三个更新：调整止损
      if (index % 4 == 0) {
        updates.add({
          'title': 'Stop Loss Updated',
          'description': 'Adjusted risk management level',
          'time': time.add(Duration(hours: 4)),
          'icon': CupertinoIcons.shield,
          'color': CupertinoColors.systemOrange,
          'data': {'New SL': '\$44,500'},
        });
      }

      // 第四个更新：部分止盈/止损
      if (index % 7 == 0) {
        final isProfit = index % 2 == 0;
        updates.add({
          'title': isProfit ? 'Take Profit' : 'Stop Loss Hit',
          'description': isProfit
              ? 'Partial profit taking'
              : 'Risk management triggered',
          'time': time.add(Duration(hours: 6)),
          'icon': isProfit
              ? CupertinoIcons.checkmark_circle
              : CupertinoIcons.xmark_circle,
          'color': isProfit
              ? CupertinoColors.systemGreen
              : CupertinoColors.systemRed,
          'data': {'PnL': isProfit ? '+\$2,500' : '-\$1,234', 'Size': '50%'},
        });
      }

      // 第五个更新：最终平仓（仅特定条件）
      if (index % 11 == 0) {
        updates.add({
          'title': 'Position Closed',
          'description': 'Full position closed successfully',
          'time': time.add(Duration(hours: 12)),
          'icon': CupertinoIcons.checkmark_circle_fill,
          'color': CupertinoColors.systemGreen,
          'data': {'Final PnL': '+\$4,567', 'ROI': '+4.5%'},
        });
      }

      signal['updates'] = updates;
    }

    return signal;
  }

  // 生成KOL喊单信号
  Map<String, dynamic> _generateKOLSignal(int index, DateTime time) {
    final kols = ['CryptoKing', 'BlockchainBull', 'AltcoinAlpha'];
    final calls = ['BUY SIGNAL', 'SELL ALERT', 'ACCUMULATE'];

    return {
      'channel': kols[index % kols.length],
      'channelColor': CupertinoColors.systemPurple,
      'channelIcon': CupertinoIcons.star_fill,
      // 1. 大标题（必有）
      'title': calls[index % calls.length],
      // 2. 副标题（可选）
      'subtitle': 'ETH/USDT Analysis',
      // 3. 正文描述（这里有描述）
      'content':
          'Technical analysis shows strong bullish momentum. Key resistance at \$2,800 broken.',
      // 4. 正文数据列表（KOL信号可选，主要靠描述）
      'customData': {
        'Entry Target': '\$2,750',
        'Stop Loss': '\$2,650',
        'Take Profit': '\$3,200',
        'Risk/Reward': '1:4.5',
      },
      'time': time,
      'views': 1200 + (index * 150),
      'updates': _generateKOLUpdates(index, time),
    };
  }

  // 为KOL信号生成follow-up更新
  List<Map<String, dynamic>> _generateKOLUpdates(int index, DateTime time) {
    if (index % 4 != 0) return [];

    final updates = <Map<String, dynamic>>[];

    // 第一个更新：确认信号
    updates.add({
      'title': 'Signal Confirmed',
      'description': 'Additional technical indicators align',
      'time': time.add(Duration(hours: 1)),
      'icon': CupertinoIcons.checkmark_alt,
      'color': CupertinoColors.systemBlue,
    });

    // 第二个更新：目标达成
    if (index % 8 == 0) {
      updates.add({
        'title': 'Target Hit',
        'description': 'First target reached as predicted',
        'time': time.add(Duration(hours: 4)),
        'icon': CupertinoIcons.checkmark_circle,
        'color': CupertinoColors.systemGreen,
        'data': {'Target 1': '\$2,850', 'Gain': '+3.2%'},
      });
    }

    // 第三个更新：调整分析
    if (index % 12 == 0) {
      updates.add({
        'title': 'Analysis Update',
        'description': 'Market conditions changed, strategy adjusted',
        'time': time.add(Duration(hours: 8)),
        'icon': CupertinoIcons.refresh,
        'color': CupertinoColors.systemOrange,
        'data': {'New Target': '\$2,950'},
      });
    }

    // 第四个更新：最终结果
    if (index % 16 == 0) {
      final success = index % 2 == 0;
      updates.add({
        'title': success ? 'Final Target Hit' : 'Signal Invalidated',
        'description': success
            ? 'All targets reached successfully'
            : 'Market conditions no longer favorable',
        'time': time.add(Duration(hours: 24)),
        'icon': success
            ? CupertinoIcons.star_fill
            : CupertinoIcons.xmark_octagon,
        'color': success
            ? CupertinoColors.systemGreen
            : CupertinoColors.systemRed,
        'data': success
            ? {'Total Gain': '+8.5%', 'Rating': '5★'}
            : {'Loss': '-2.1%'},
      });
    }

    return updates;
  }

  // 格式化金额显示
  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  // 生成链上DCA信号
  Map<String, dynamic> _generateDCASignal(int index, DateTime time) {
    final fromTokens = ['WBTC', 'ETH', 'USDC', 'WETH', 'DAI'];
    final toTokens = [
      'Fartcoin',
      'PEPE',
      'SHIB',
      'DOGE',
      'BONK',
      'WIF',
      'POPCAT',
    ];
    final prices = [55689.08, 3245.67, 1.0, 3234.89, 1.0];

    final fromToken = fromTokens[index % fromTokens.length];
    final toToken = toTokens[index % toTokens.length];
    final price = prices[index % prices.length];

    // 生成DCA参数
    final swapAmount = (5000 + (index * 1234.5) % 15000).toStringAsFixed(2);
    final swapInterval = [15, 30, 60, 120, 300][index % 5]; // seconds
    final duration = [1, 3, 5, 10, 15][index % 5]; // minutes

    // 生成流动性和市值数据
    final liq = (10000 + (index * 5678.9) % 50000).toStringAsFixed(2);
    final mc = (500000 + (index * 12345.6) % 1000000).toStringAsFixed(2);
    final ratio = ((double.parse(liq) / double.parse(mc)) * 100)
        .toStringAsFixed(2);

    // 生成买入比例
    final buyLiq = (0.1 + (index * 0.05) % 0.5).toStringAsFixed(2);
    final buyMC = (0.005 + (index * 0.002) % 0.02).toStringAsFixed(3);

    return {
      'channel': 'DCA Bot',
      'channelColor': CupertinoColors.systemTeal,
      'channelIcon': CupertinoIcons.arrow_2_circlepath,
      // 1. 大标题（必有）
      'title': '$fromToken ➜ $toToken',
      // 2. 副标题（可选）
      'subtitle': '\$${price.toStringAsFixed(2)}',
      // 3. 正文描述（这里有简化的描述）
      'content':
          'Swap \$${swapAmount}/${swapInterval}s for ${duration}min, Buy/Liq: ${buyLiq}%, Buy/MC: ${buyMC}%',
      // 4. 正文数据列表（DCA的关键数据）
      'customData': {
        'Amount': '\$${swapAmount}',
        'Interval': '${swapInterval}s',
        'Duration': '${duration}min',
        'Liquidity': '\$${liq}K',
        'Market Cap': '\$${mc}K',
        'Liq Ratio': '${ratio}%',
      },
      'time': time,
      'followers': 89 + (index * 15),
      'updates': _generateDCAUpdates(index, time),
    };
  }

  // 为DCA信号生成follow-up更新
  List<Map<String, dynamic>> _generateDCAUpdates(int index, DateTime time) {
    if (index % 5 != 0) return [];

    final updates = <Map<String, dynamic>>[];

    // 第一个更新：DCA开始
    updates.add({
      'title': 'DCA Started',
      'description': 'Automated buying sequence initiated',
      'time': time.add(Duration(minutes: 2)),
      'icon': CupertinoIcons.play_circle,
      'color': CupertinoColors.systemGreen,
      'data': {'Status': 'Active', 'Progress': '0%'},
    });

    // 第二个更新：进度更新
    if (index % 10 == 0) {
      updates.add({
        'title': 'DCA Progress',
        'description': 'Partial execution completed',
        'time': time.add(Duration(minutes: 8)),
        'icon': CupertinoIcons.clock,
        'color': CupertinoColors.systemBlue,
        'data': {'Progress': '40%', 'Avg Price': '\$0.00234'},
      });
    }

    // 第三个更新：价格异常
    if (index % 15 == 0) {
      updates.add({
        'title': 'Price Alert',
        'description': 'Significant price movement detected',
        'time': time.add(Duration(minutes: 12)),
        'icon': CupertinoIcons.exclamationmark_triangle,
        'color': CupertinoColors.systemOrange,
        'data': {'Price Change': '+15.6%', 'Action': 'Continued'},
      });
    }

    // 第四个更新：DCA完成
    if (index % 20 == 0) {
      final success = index % 4 != 0;
      updates.add({
        'title': success ? 'DCA Completed' : 'DCA Stopped',
        'description': success
            ? 'All scheduled purchases executed'
            : 'Stopped due to market conditions',
        'time': time.add(Duration(minutes: 20)),
        'icon': success
            ? CupertinoIcons.checkmark_circle_fill
            : CupertinoIcons.stop_circle,
        'color': success
            ? CupertinoColors.systemGreen
            : CupertinoColors.systemRed,
        'data': success
            ? {
                'Total Spent': '\$9,281',
                'Avg Price': '\$0.00198',
                'Tokens': '4.69M',
              }
            : {'Spent': '\$4,640', 'Reason': 'High Slippage'},
      });
    }

    return updates;
  }

  // 生成新闻/分析信号
  Map<String, dynamic> _generateNewsSignal(int index, DateTime time) {
    final sources = ['CoinDesk', 'CryptoNews', 'BlockBeats'];
    final titles = [
      'Bitcoin ETF Approval Imminent',
      'Ethereum 2.0 Staking Reaches New High',
      'Major Exchange Lists New Altcoin',
    ];

    return {
      'channel': sources[index % sources.length],
      'channelColor': CupertinoColors.systemOrange,
      'channelIcon': CupertinoIcons.news,
      // 1. 大标题（必有）
      'title': titles[index % titles.length],
      // 2. 副标题（可选 - 新闻信号通常不需要）
      // 3. 正文描述（新闻信号主要靠描述，不需要数据列表）
      'content':
          'Market analysis suggests significant price movement incoming based on fundamental developments.',
      // 4. 正文数据列表（新闻信号通常不需要）
      'time': time,
      'views': 5000 + (index * 200),
      'maxLines': 2,
      'updates': [],
    };
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
          final unreadCount = _getUnreadCount(collection);

          return Padding(
            key: ValueKey(collection),
            padding: EdgeInsets.only(right: 6.0),
            child: GestureDetector(
              onTap: () => appState.setSelectedCollection(collection),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
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
                              : CupertinoColors.secondaryLabel.resolveFrom(
                                  context,
                                ),
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  // 未读信号徽章
                  if (unreadCount > 0 && !isSelected)
                    _buildUnreadBadge(unreadCount),
                ],
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
        title: Text('Create New Collection'),
        content: Padding(
          padding: EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: controller,
            placeholder: 'Enter collection name (e.g., "Meme Coins")',
            autofocus: true,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Create'),
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

    if (appState.selectedCollection == 'All') {
      return _allMessages;
    }

    // 根据集合筛选消息
    return _allMessages.where((message) {
      final channel = message['channel'] as String;
      return _isChannelInCollection(channel, appState.selectedCollection);
    }).toList();
  }

  // 判断信号是否属于指定集合
  bool _isChannelInCollection(String channel, String collection) {
    switch (collection) {
      case 'Whales':
        // 巨鲸信号：包含所有巨鲸地址
        return ['0x7f...a9e2', '0x1a...b8c4', '0x2d...f3a1'].contains(channel);
      case 'KOL':
        // KOL信号：包含所有KOL
        return [
          'CryptoKing',
          'BlockchainBull',
          'AltcoinAlpha',
        ].contains(channel);
      case 'DCA':
        // DCA信号：自动投资机器人
        return channel == 'DCA Bot';
      case 'News':
        // 新闻信号：各大资讯平台
        return ['CoinDesk', 'CryptoNews', 'BlockBeats'].contains(channel);
      case 'Futures':
        // 合约交易：包含有杠杆的信号（通过检查customData中是否有Leverage字段）
        return _hasLeverageData(channel);
      case 'Spot':
        // 现货交易：不包含杠杆的交易信号
        return _isSpotTrading(channel);
      default:
        return true;
    }
  }

  // 检查是否包含杠杆数据（合约交易）
  bool _hasLeverageData(String channel) {
    // 巨鲸信号通常包含杠杆信息
    return ['0x7f...a9e2', '0x1a...b8c4', '0x2d...f3a1'].contains(channel);
  }

  // 检查是否为现货交易
  bool _isSpotTrading(String channel) {
    // KOL信号和新闻通常是现货相关
    return [
      'CryptoKing',
      'BlockchainBull',
      'AltcoinAlpha',
      'CoinDesk',
      'CryptoNews',
      'BlockBeats',
    ].contains(channel);
  }

  // 获取指定集合的未读信号数量
  int _getUnreadCount(String collection) {
    if (collection == 'All') {
      // All集合显示总的未读数量
      return _allMessages.where((message) => _isRecentSignal(message)).length;
    }

    // 其他集合显示该集合的未读数量
    return _allMessages.where((message) {
      final channel = message['channel'] as String;
      return _isChannelInCollection(channel, collection) &&
          _isRecentSignal(message);
    }).length;
  }

  // 判断是否为最近的信号（30分钟内为未读）
  bool _isRecentSignal(Map<String, dynamic> message) {
    final messageTime = message['time'] as DateTime;
    final now = DateTime.now();
    final difference = now.difference(messageTime);
    // 只有30分钟内的信号才算未读，这样红点会更少更有意义
    return difference.inMinutes < 30;
  }

  // 构建未读信号徽章 - 小红点
  Widget _buildUnreadBadge(int count) {
    return Positioned(
      top: 2,
      right: 2,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: CupertinoColors.systemRed,
          shape: BoxShape.circle,
          border: Border.all(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? CupertinoColors.systemBackground.resolveFrom(context)
                : Color(0xFFEEF0F4),
            width: 1,
          ),
        ),
      ),
    );
  }

  // 构建底部加载指示器
  Widget _buildLoadingIndicator() {
    if (_isLoadingMore) {
      // 正在加载更多
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              CupertinoActivityIndicator(),
              SizedBox(height: 8),
              Text(
                'Loading...',
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (!_hasMoreData) {
      // 没有更多数据
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'End of the line :-)',
            style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 14),
          ),
        ),
      );
    } else {
      // 还有更多数据，但暂时不显示任何内容
      return SizedBox(height: 16);
    }
  }

  // 构建统一的增强信号卡片
  Widget _buildMessageItem(Map<String, dynamic> signal) {
    return EnhancedSignalCard(
      signal: signal,
      onTap: () {
        // 点击查看信号详情
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
          ? CupertinoColors.systemBackground.resolveFrom(context)
          : Color(0xFFEEF0F4),
      child: CustomScrollView(
        controller: _scrollController,
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
                child: _buildMessageItem(message),
              );
            }, childCount: _getFilteredMessages().length),
          ),

          // 底部加载指示器
          SliverToBoxAdapter(child: _buildLoadingIndicator()),

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
