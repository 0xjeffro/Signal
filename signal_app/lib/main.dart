import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'widgets/draggable_bottom_sheet.dart';
import 'widgets/custom_tab_bar.dart';
import 'pages/home_page.dart';
import 'pages/explore_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: CupertinoApp(
        theme: CupertinoThemeData(primaryColor: CupertinoColors.systemBlue),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('en', 'US'), Locale('zh', 'CN')],
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int selectedIndex = 0;
  bool isBottomSheetExpanded = false;

  // 集合相关状态
  String selectedCollection = 'All';
  List<String> collections = [
    'All',
    'iOS开发',
    'Flutter',
    'Apple',
    '设计规范',
    '工具技巧',
  ];

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void toggleBottomSheet() {
    isBottomSheetExpanded = !isBottomSheetExpanded;
    notifyListeners();
  }

  void setSelectedCollection(String collection) {
    selectedCollection = collection;
    notifyListeners();
  }

  void addCollection(String collectionName) {
    if (!collections.contains(collectionName)) {
      collections.add(collectionName);
      notifyListeners();
    }
  }

  void reorderCollections(int oldIndex, int newIndex) {
    // 保护 "All" 标签，它始终在第一位
    if (oldIndex == 0 || newIndex == 0) return;

    // 调整索引，因为ReorderableListView的逻辑
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final String item = collections.removeAt(oldIndex);
    collections.insert(newIndex, item);
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
          ? CupertinoColors.systemBackground.resolveFrom(context)
          : Color(0xFFEEF0F4),
      body: Stack(
        children: [
          // 让背景内容延伸到底部，为毛玻璃效果提供背景
          Positioned.fill(child: _buildBody(appState)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DraggableBottomSheet(
              appState: appState,
              title: _getTitleForCurrentTab(appState.selectedIndex),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomTabBar(),
    );
  }

  Widget _buildBody(MyAppState appState) {
    switch (appState.selectedIndex) {
      case 0:
        return HomePage(appState: appState);
      case 1:
        return ExplorePage();
      case 2:
        return SettingsPage();
      default:
        return Container();
    }
  }

  String _getTitleForCurrentTab(int index) {
    switch (index) {
      case 0:
        return 'Inbox';
      case 1:
        return 'Explore';
      case 2:
        return 'Settings';
      default:
        return 'Quick Actions';
    }
  }
}
