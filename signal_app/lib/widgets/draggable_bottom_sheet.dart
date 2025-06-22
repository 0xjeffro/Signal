import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class DraggableBottomSheet extends StatefulWidget {
  final MyAppState appState;

  const DraggableBottomSheet({super.key, required this.appState});

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
      duration: Duration(milliseconds: 300),
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
          _currentHeight -= details.delta.dy;
          _currentHeight = _currentHeight.clamp(_minHeight, _maxHeight);
        });
      },
      onVerticalDragEnd: (details) {
        if (_currentHeight > (_minHeight + _maxHeight) / 2) {
          _expandSheet();
        } else {
          _collapseSheet();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: _currentHeight,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag Handle
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey3,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Quick Actions文本
            Padding(
              padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // 分割线在Quick Actions底部，延伸到全宽
            Container(
              height: 0.5,
              width: double.infinity,
              color: CupertinoColors.systemGrey4,
            ),
            // 剩余空间
            Expanded(child: Container()),
          ],
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
