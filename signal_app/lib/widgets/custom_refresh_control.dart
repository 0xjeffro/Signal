import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CustomRefreshControl extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;

  const CustomRefreshControl({
    super.key,
    required this.onRefresh,
    this.refreshTriggerPullDistance = 60.0,
    this.refreshIndicatorExtent = 60.0,
  });

  @override
  State<CustomRefreshControl> createState() => _CustomRefreshControlState();
}

class _CustomRefreshControlState extends State<CustomRefreshControl>
    with TickerProviderStateMixin {
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
    setState(() {
      _isRefreshing = true;
      _hasTriggeredHaptic = false;
    });

    await widget.onRefresh();

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      onRefresh: _handleRefresh,
      refreshTriggerPullDistance: widget.refreshTriggerPullDistance,
      refreshIndicatorExtent: widget.refreshIndicatorExtent,
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

            if (refreshState == RefreshIndicatorMode.refresh || _isRefreshing) {
              // 刷新状态：显示标准的加载动画
              indicator = CupertinoActivityIndicator(radius: 12.0);
            } else {
              // 下拉状态：只显示向下箭头
              double pullProgress = (pulledExtent / refreshTriggerPullDistance)
                  .clamp(0.0, 1.0);
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
                padding: EdgeInsets.only(top: topPadding + 30.0, bottom: 8.0),
                child: indicator,
              ),
            );
          },
    );
  }
}
