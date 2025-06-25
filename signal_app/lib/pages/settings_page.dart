import 'package:flutter/cupertino.dart';
import 'profile_page.dart';

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
      child: CustomScrollView(
        slivers: [
          // iOS风格的大标题导航栏
          CupertinoSliverNavigationBar(
            largeTitle: Text('Settings'),
            backgroundColor:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                ? CupertinoColors.systemBackground.resolveFrom(context)
                : Color(0xFFEEF0F4),
          ),

          // 主要内容
          SliverToBoxAdapter(
            child: Column(
              children: [
                // 用户信息卡片
                _buildUserProfileCard(context),

                // 设置选项组
                _buildSettingsGroup(
                  context,
                  items: [
                    _SettingsItem(
                      icon: CupertinoIcons.creditcard,
                      iconColor: CupertinoColors.systemBlue,
                      title: 'Wallet',
                      subtitle: 'Balance, Security, Transaction history',
                      onTap: () => _showComingSoon(context, 'Wallet'),
                    ),
                    _SettingsItem(
                      icon: CupertinoIcons.chat_bubble_2,
                      iconColor: CupertinoColors.systemGreen,
                      title: 'Chats',
                      subtitle: 'Theme, Wallpapers, Chat history',
                      onTap: () => _showComingSoon(context, 'Chats'),
                    ),
                    _SettingsItem(
                      icon: CupertinoIcons.bell,
                      iconColor: CupertinoColors.systemRed,
                      title: 'Notifications',
                      subtitle: 'Message, Group & Call tones',
                      onTap: () => _showComingSoon(context, 'Notifications'),
                    ),
                    _SettingsItem(
                      icon: CupertinoIcons.folder,
                      iconColor: CupertinoColors.systemOrange,
                      title: 'Storage and Data',
                      subtitle: 'Network usage, Auto-download',
                      onTap: () => _showComingSoon(context, 'Storage'),
                    ),
                  ],
                ),

                _buildSettingsGroup(
                  context,
                  items: [
                    _SettingsItem(
                      icon: CupertinoIcons.question_circle,
                      iconColor: CupertinoColors.systemTeal,
                      title: 'Help',
                      onTap: () => _showComingSoon(context, 'Help'),
                    ),
                    _SettingsItem(
                      icon: CupertinoIcons.heart,
                      iconColor: CupertinoColors.systemPink,
                      title: 'Invite Friends',
                      onTap: () => _showComingSoon(context, 'Invite'),
                    ),
                  ],
                ),

                _buildSettingsGroup(
                  context,
                  items: [
                    _SettingsItem(
                      icon: CupertinoIcons.brightness,
                      iconColor: CupertinoColors.systemIndigo,
                      title: 'Appearance',
                      subtitle: 'Theme, Interface scale',
                      onTap: () => _showComingSoon(context, 'Appearance'),
                    ),
                    _SettingsItem(
                      icon: CupertinoIcons.globe,
                      iconColor: CupertinoColors.systemPurple,
                      title: 'Language',
                      subtitle: 'English',
                      onTap: () => _showComingSoon(context, 'Language'),
                    ),
                  ],
                ),

                SizedBox(height: 120), // 为bottom sheet留空间
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(
        context,
      ).push(CupertinoPageRoute(builder: (context) => ProfilePage())),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? CupertinoColors.systemGrey6.resolveFrom(context)
              : CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CupertinoColors.systemGrey5
                .resolveFrom(context)
                .withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // 头像
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? CupertinoColors.systemGrey4.resolveFrom(context)
                      : CupertinoColors.systemGrey5.resolveFrom(context),
                  width: 2,
                ),
                gradient: LinearGradient(
                  colors: [
                    CupertinoColors.systemBlue,
                    CupertinoColors.systemPurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  'J',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),

            // 用户信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Johan Ng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label.resolveFrom(context),
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 0),
                  Text(
                    '+1 (555) 123-4567',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: CupertinoColors.secondaryLabel.resolveFrom(
                        context,
                      ),
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: -1),
                  Text(
                    '@johanng',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.systemBlue.resolveFrom(context),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // 进入箭头
            Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey3.resolveFrom(context),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context, {
    required List<_SettingsItem> items,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? CupertinoColors.systemGrey6.resolveFrom(context)
            : CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey5
              .resolveFrom(context)
              .withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildSettingsItem(context, items[i]),
            if (i < items.length - 1)
              Container(
                margin: EdgeInsets.only(left: 58),
                height: 0.5,
                color: CupertinoColors.systemGrey4.resolveFrom(context),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, _SettingsItem item) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: item.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // 图标
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: item.iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 18),
            ),
            SizedBox(width: 12),

            // 文字信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    SizedBox(height: 1),
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel.resolveFrom(
                          context,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // 箭头
            Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey3.resolveFrom(context),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Coming Soon'),
        content: Text('$feature feature will be available in a future update.'),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}
