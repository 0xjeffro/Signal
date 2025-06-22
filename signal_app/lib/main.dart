import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'widgets/draggable_bottom_sheet.dart';
import 'pages/home_page.dart';

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
        theme: CupertinoThemeData(primaryColor: CupertinoColors.systemOrange),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int selectedIndex = 0;
  bool isBottomSheetExpanded = false;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void toggleBottomSheet() {
    isBottomSheetExpanded = !isBottomSheetExpanded;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Stack(
        children: [
          _buildBody(appState),
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
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: appState.selectedIndex,
        onTap: (index) {
          HapticFeedback.lightImpact();
          appState.setSelectedIndex(index);
        },
        backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
        activeColor: CupertinoColors.systemBlue,
        inactiveColor: CupertinoColors.systemGrey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tray_fill, size: 22),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.scope, size: 22),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 22),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(MyAppState appState) {
    switch (appState.selectedIndex) {
      case 0:
        return HomePage(appState: appState);
      case 1:
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(middle: Text('Explore')),
          child: _buildExploreTab(),
        );
      case 2:
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(middle: Text('Settings')),
          child: _buildSettingsTab(),
        );
      default:
        return Container();
    }
  }

  Widget _buildExploreTab() {
    return SafeArea(
      child: Center(
        child: Text('Explore will go here', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SafeArea(
      child: Center(
        child: Text('Settings will go here', style: TextStyle(fontSize: 18)),
      ),
    );
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
