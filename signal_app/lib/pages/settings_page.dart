import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
          ? CupertinoColors.systemBackground.resolveFrom(context)
          : Color(0xFFEEF0F4),
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
            ? CupertinoColors.systemBackground.resolveFrom(context)
            : Color(0xFFEEF0F4),
      ),
      child: SafeArea(
        child: Center(
          child: Text('Settings will go here', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
