import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/draggable_bottom_sheet.dart';

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
        onTap: (index) => appState.setSelectedIndex(index),
        backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
        activeColor: CupertinoColors.systemBlue,
        inactiveColor: CupertinoColors.systemGrey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(MyAppState appState) {
    switch (appState.selectedIndex) {
      case 0:
        return CupertinoPageScaffold(child: _buildHomeTab(appState));
      case 1:
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(middle: Text('Favorites')),
          child: _buildFavoritesTab(),
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

  Widget _buildHomeTab(MyAppState appState) {
    return SafeArea(
      child: Center(
        child: Text(
          'Home Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return SafeArea(
      child: Center(
        child: Text('Favorites will go here', style: TextStyle(fontSize: 18)),
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
        return 'Home';
      case 1:
        return 'Favorites';
      case 2:
        return 'Settings';
      default:
        return 'Quick Actions';
    }
  }
}
