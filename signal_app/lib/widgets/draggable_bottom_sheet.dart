import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../main.dart';

class DraggableBottomSheet extends StatefulWidget {
  final MyAppState appState;
  final String title;

  const DraggableBottomSheet({
    super.key,
    required this.appState,
    this.title = 'Quick Actions',
  });

  @override
  State<DraggableBottomSheet> createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _currentHeight = 50.5;
  final double _minHeight = 50.5;
  final double _maxHeight = 300.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          // 增加拖拽敏感度，让滑动更跟手
          _currentHeight -= details.delta.dy * 1.2;
          _currentHeight = _currentHeight.clamp(_minHeight, _maxHeight);
        });
      },
      onVerticalDragEnd: (details) {
        // 根据拖拽速度和位置来决定展开或收起
        double velocity = details.primaryVelocity ?? 0;

        if (velocity < -300) {
          // 快速向上滑动，展开
          _expandSheet();
        } else if (velocity > 300) {
          // 快速向下滑动，收起
          _collapseSheet();
        } else {
          // 根据位置判断
          if (_currentHeight > (_minHeight + _maxHeight) / 2) {
            _expandSheet();
          } else {
            _collapseSheet();
          }
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        curve: Cubic(0.175, 0.885, 0.32, 1.1),
        height: _currentHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? CupertinoColors.systemGrey5
                          .resolveFrom(context)
                          .withOpacity(0.60)
                    : CupertinoColors.systemBackground
                          .resolveFrom(context)
                          .withOpacity(0.55),
                // 移除边框，让与tabbar完全融合
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey3.resolveFrom(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // 标题文本
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 9),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.label.resolveFrom(context),
                        ),
                      ),
                    ),
                  ),
                  // 分割线在Quick Actions底部，延伸到全宽
                  Container(
                    height: 0.33,
                    width: double.infinity,
                    color: CupertinoColors.systemGrey4.resolveFrom(context),
                  ),
                  // 剩余空间
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _expandSheet() {
    setState(() {
      _currentHeight = _maxHeight;
    });
  }

  void _collapseSheet() {
    setState(() {
      _currentHeight = _minHeight;
    });
  }
}
