import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../main.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? CupertinoColors.systemGrey5
                      .resolveFrom(context)
                      .withOpacity(0.5)
                : CupertinoColors.systemBackground
                      .resolveFrom(context)
                      .withOpacity(0.5),
          ),
          child: CupertinoTabBar(
            currentIndex: appState.selectedIndex,
            onTap: (index) {
              HapticFeedback.lightImpact();
              appState.setSelectedIndex(index);
            },
            backgroundColor: Colors.transparent,
            activeColor: CupertinoColors.systemBlue.resolveFrom(context),
            inactiveColor: CupertinoColors.systemGrey.resolveFrom(context),
            border: null,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/inbox.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    appState.selectedIndex == 0
                        ? CupertinoColors.systemBlue.resolveFrom(context)
                        : CupertinoColors.systemGrey.resolveFrom(context),
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/explore.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    appState.selectedIndex == 1
                        ? CupertinoColors.systemBlue.resolveFrom(context)
                        : CupertinoColors.systemGrey.resolveFrom(context),
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/settings.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    appState.selectedIndex == 2
                        ? CupertinoColors.systemBlue.resolveFrom(context)
                        : CupertinoColors.systemGrey.resolveFrom(context),
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
