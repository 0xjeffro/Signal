import 'package:flutter/cupertino.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final TextEditingController _nickNameController = TextEditingController(
    text: 'Johan Ng',
  );
  final TextEditingController _usernameController = TextEditingController(
    text: '@johanng',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'johan.ng@example.com',
  );

  @override
  void dispose() {
    _nickNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
          ? CupertinoColors.systemBackground.resolveFrom(context)
          : Color(0xFFEEF0F4),
      navigationBar: CupertinoNavigationBar(
        middle: Text('Profile'),
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
            ? CupertinoColors.systemBackground.resolveFrom(context)
            : Color(0xFFEEF0F4),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            'Save',
            style: TextStyle(
              color: CupertinoColors.systemBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () => _saveProfile(),
        ),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            // 点击空白区域收回键盘
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),

                // 头像
                _buildAvatar(),

                SizedBox(height: 40),

                // 姓名组
                _buildNameSection(),

                SizedBox(height: 20),

                // 联系信息组
                _buildContactSection(),

                SizedBox(height: 40),

                // 登出按钮
                _buildLogOutButton(),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () => _showChangeAvatarOptions(),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? CupertinoColors.systemGrey4.resolveFrom(context)
                : CupertinoColors.systemGrey5.resolveFrom(context),
            width: 3,
          ),
          gradient: LinearGradient(
            colors: [CupertinoColors.systemBlue, CupertinoColors.systemPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            'J',
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
          _buildTextFieldItem(
            controller: _nickNameController,
            label: 'Nick Name',
            isFirst: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
          _buildLabelValueItem(
            label: 'Phone Number',
            value: '+1 (555) 123-4567',
            onTap: () => _showComingSoon('Phone Number'),
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            height: 0.5,
            color: CupertinoColors.systemGrey4.resolveFrom(context),
          ),
          _buildLabelValueItem(
            label: 'Username',
            value: _usernameController.text,
            onTap: () => _showUsernameEdit(),
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            height: 0.5,
            color: CupertinoColors.systemGrey4.resolveFrom(context),
          ),
          _buildLabelValueItem(
            label: 'Email',
            value: _emailController.text,
            onTap: () => _showEmailEdit(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldItem({
    required TextEditingController controller,
    required String label,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              decoration: null,
              padding: EdgeInsets.zero,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: CupertinoColors.label.resolveFrom(context),
              ),
              placeholder: 'Tap to edit',
              placeholderStyle: TextStyle(
                color: CupertinoColors.systemGrey3.resolveFrom(context),
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
              clearButtonMode: OverlayVisibilityMode.editing,
              textInputAction: TextInputAction.done,
              enableInteractiveSelection: true,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.text,
              onSubmitted: (value) {
                // 点击键盘上的完成按钮收回键盘
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValueItem({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(width: 8),
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

  Widget _buildLogOutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _showLogOutConfirmation(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: Text(
              'Log Out',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.systemRed,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showChangeAvatarOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Change Profile Photo'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('Take Photo'),
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Take Photo');
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Choose from Library'),
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Photo Library');
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _saveProfile() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Profile Updated'),
        content: Text('Your profile has been saved successfully.'),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showLogOutConfirmation() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out of your account?'),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('Log Out'),
            onPressed: () => _performLogOut(),
          ),
        ],
      ),
    );
  }

  void _performLogOut() async {
    Navigator.of(context).pop(); // 关闭确认对话框

    // 添加短暂延迟，让对话框关闭动画完成
    await Future.delayed(Duration(milliseconds: 200));

    // 显示精美的加载指示器
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _LogoutLoadingIndicator(),
    );

    // 模拟登出处理时间
    await Future.delayed(Duration(milliseconds: 800));

    // 关闭加载指示器并跳转到登录页面
    Navigator.of(context).pop(); // 关闭加载指示器

    // 使用自定义的淡入淡出过渡动画
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        transitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      (route) => false,
    );
  }

  void _showUsernameEdit() {
    _showComingSoon('Username Edit');
  }

  void _showEmailEdit() {
    _showComingSoon('Email Edit');
  }

  void _showComingSoon(String feature) {
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

// 简洁的登出加载指示器
class _LogoutLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 140,
        height: 120,
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? CupertinoColors.systemGrey6
                    .resolveFrom(context)
                    .withOpacity(0.9)
              : CupertinoColors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 简单的系统加载指示器
            CupertinoActivityIndicator(radius: 18),
            SizedBox(height: 16),
            Text(
              'Logging out...',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
