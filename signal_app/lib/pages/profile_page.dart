import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController(
    text: 'Johan',
  );
  final TextEditingController _lastNameController = TextEditingController(
    text: 'Ng',
  );
  final TextEditingController _usernameController = TextEditingController(
    text: '@johanng',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'johan.ng@example.com',
  );

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
            controller: _firstNameController,
            label: 'First Name',
            isFirst: true,
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            height: 0.5,
            color: CupertinoColors.systemGrey4.resolveFrom(context),
          ),
          _buildTextFieldItem(
            controller: _lastNameController,
            label: 'Last Name',
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ),
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              decoration: BoxDecoration(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: CupertinoColors.label.resolveFrom(context),
              ),
              placeholder: 'Enter $label',
              placeholderStyle: TextStyle(
                color: CupertinoColors.systemGrey3.resolveFrom(context),
              ),
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
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // 返回到settings页面
              _showComingSoon('Log Out');
            },
          ),
        ],
      ),
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
