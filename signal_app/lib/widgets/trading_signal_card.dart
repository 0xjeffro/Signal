import 'package:flutter/cupertino.dart';

// 交易动作类型枚举
enum TradeAction {
  open, // 开仓
  addPosition, // 加仓
  reducePosition, // 减仓
  takeProfit, // 止盈
  stopLoss, // 止损
  close, // 平仓
}

// 交易状态枚举
enum TradeStatus {
  active, // 活跃中
  closed, // 已关闭
  liquidated, // 已清算
}

// 单个交易操作的数据结构
class TradeUpdate {
  final TradeAction action;
  final DateTime time;
  final double? price;
  final double? amount;
  final double? pnl; // 盈亏
  final String? note; // 备注

  TradeUpdate({
    required this.action,
    required this.time,
    this.price,
    this.amount,
    this.pnl,
    this.note,
  });
}

class TradingSignalCard extends StatefulWidget {
  final Map<String, dynamic> signal;
  final VoidCallback? onTap;

  const TradingSignalCard({super.key, required this.signal, this.onTap});

  @override
  State<TradingSignalCard> createState() => _TradingSignalCardState();
}

class _TradingSignalCardState extends State<TradingSignalCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final signal = widget.signal;
    final List<TradeUpdate> updates = signal['updates'] ?? [];
    final TradeStatus status = signal['status'] ?? TradeStatus.active;
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
            color: _getBorderColor(status, context),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部信息：巨鲸地址 + 时间 + 状态
              Row(
                children: [
                  // 巨鲸标识
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.graph_circle_fill,
                          size: 12,
                          color: CupertinoColors.systemBlue,
                        ),
                        SizedBox(width: 4),
                        Text(
                          signal['whaleAddress'] ?? 'Whale',
                          style: TextStyle(
                            color: CupertinoColors.systemBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // 状态指示器
                  _buildStatusIndicator(status),
                  SizedBox(width: 8),
                  Text(
                    _formatTime(signal['time']),
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // 主要交易信息
              _buildMainTradeInfo(signal),

              // Follow-up 更新（如果有的话）
              if (hasUpdates) ...[
                SizedBox(height: 12),
                _buildFollowUpSection(updates),
              ],

              SizedBox(height: 12),

              // 底部操作栏
              _buildBottomActions(hasUpdates),
            ],
          ),
        ),
      ),
    );
  }

  // 构建主要交易信息
  Widget _buildMainTradeInfo(Map<String, dynamic> signal) {
    final String pair = signal['pair'] ?? 'BTC/USDT';
    final String side = signal['side'] ?? 'LONG';
    final double? entryPrice = signal['entryPrice'];
    final double? amount = signal['amount'];
    final double? leverage = signal['leverage'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 交易对 + 方向
        Row(
          children: [
            Text(
              pair,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: side == 'LONG'
                    ? CupertinoColors.systemGreen.withOpacity(0.15)
                    : CupertinoColors.systemRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                side,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: side == 'LONG'
                      ? CupertinoColors.systemGreen
                      : CupertinoColors.systemRed,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),

        // 交易详情
        Row(
          children: [
            if (entryPrice != null) ...[
              Text(
                'Entry: \$${entryPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
              SizedBox(width: 16),
            ],
            if (amount != null) ...[
              Text(
                'Size: \$${_formatAmount(amount)}',
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
              SizedBox(width: 16),
            ],
            if (leverage != null) ...[
              Text(
                '${leverage.toStringAsFixed(0)}x',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemOrange,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // 构建Follow-up更新部分
  Widget _buildFollowUpSection(List<TradeUpdate> updates) {
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
            Spacer(),
            if (updates.length > 2)
              CupertinoButton(
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
  Widget _buildUpdateItem(TradeUpdate update) {
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
          // 动作图标
          Icon(
            _getActionIcon(update.action),
            size: 16,
            color: _getActionColor(update.action),
          ),
          SizedBox(width: 8),

          // 动作描述
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getActionDescription(update),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                if (update.pnl != null) ...[
                  SizedBox(height: 2),
                  Text(
                    'PnL: ${update.pnl! >= 0 ? '+' : ''}\$${update.pnl!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: update.pnl! >= 0
                          ? CupertinoColors.systemGreen
                          : CupertinoColors.systemRed,
                    ),
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
  Widget _buildBottomActions(bool hasUpdates) {
    return Row(
      children: [
        Icon(CupertinoIcons.bell, size: 14, color: CupertinoColors.systemGrey),
        SizedBox(width: 4),
        Text(
          '${widget.signal['followers'] ?? 0} followers',
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
              '${(widget.signal['updates'] as List).length} updates',
              style: TextStyle(
                fontSize: 11,
                color: CupertinoColors.systemBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        Spacer(),
        CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          onPressed: widget.onTap,
          child: Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }

  // 获取状态指示器
  Widget _buildStatusIndicator(TradeStatus status) {
    Color color;

    switch (status) {
      case TradeStatus.active:
        color = CupertinoColors.systemGreen;
        break;
      case TradeStatus.closed:
        color = CupertinoColors.systemGrey;
        break;
      case TradeStatus.liquidated:
        color = CupertinoColors.systemRed;
        break;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  // 获取边框颜色
  Color _getBorderColor(TradeStatus status, BuildContext context) {
    switch (status) {
      case TradeStatus.active:
        return CupertinoColors.systemGreen.withOpacity(0.3);
      case TradeStatus.closed:
        return CupertinoColors.systemGrey5
            .resolveFrom(context)
            .withOpacity(0.3);
      case TradeStatus.liquidated:
        return CupertinoColors.systemRed.withOpacity(0.3);
    }
  }

  // 获取交易动作图标
  IconData _getActionIcon(TradeAction action) {
    switch (action) {
      case TradeAction.open:
        return CupertinoIcons.play_circle;
      case TradeAction.addPosition:
        return CupertinoIcons.plus_circle;
      case TradeAction.reducePosition:
        return CupertinoIcons.minus_circle;
      case TradeAction.takeProfit:
        return CupertinoIcons.checkmark_circle;
      case TradeAction.stopLoss:
        return CupertinoIcons.xmark_circle;
      case TradeAction.close:
        return CupertinoIcons.stop_circle;
    }
  }

  // 获取交易动作颜色
  Color _getActionColor(TradeAction action) {
    switch (action) {
      case TradeAction.open:
        return CupertinoColors.systemBlue;
      case TradeAction.addPosition:
        return CupertinoColors.systemGreen;
      case TradeAction.reducePosition:
        return CupertinoColors.systemOrange;
      case TradeAction.takeProfit:
        return CupertinoColors.systemGreen;
      case TradeAction.stopLoss:
        return CupertinoColors.systemRed;
      case TradeAction.close:
        return CupertinoColors.systemGrey;
    }
  }

  // 获取交易动作描述
  String _getActionDescription(TradeUpdate update) {
    String action = '';

    switch (update.action) {
      case TradeAction.open:
        action = 'Opened position';
        break;
      case TradeAction.addPosition:
        action = 'Added to position';
        break;
      case TradeAction.reducePosition:
        action = 'Reduced position';
        break;
      case TradeAction.takeProfit:
        action = 'Take profit';
        break;
      case TradeAction.stopLoss:
        action = 'Stop loss triggered';
        break;
      case TradeAction.close:
        action = 'Closed position';
        break;
    }

    if (update.price != null) {
      action += ' at \$${update.price!.toStringAsFixed(2)}';
    }

    if (update.amount != null) {
      action += ' (\$${_formatAmount(update.amount!)})';
    }

    return action;
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
