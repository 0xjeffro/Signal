import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  final MyAppState appState;

  const HomePage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          // iOS风格的Collapsing Navigation Bar
          CupertinoSliverNavigationBar(
            largeTitle: Text('Inbox'),
            backgroundColor: CupertinoColors.systemBackground,
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
                      'Home页面内容\n在这里添加你的功能',
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
