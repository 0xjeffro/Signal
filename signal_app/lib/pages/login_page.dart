import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  // 国家代码相关
  String _selectedCountryCode = '+1';
  String _selectedCountryName = 'United States';
  String _selectedCountryFlag = '🇺🇸';

  // 常用国家列表
  final List<Map<String, String>> _countries = [
    {'name': 'Afghanistan', 'code': '+93', 'flag': '🇦🇫'},
    {'name': 'Albania', 'code': '+355', 'flag': '🇦🇱'},
    {'name': 'Algeria', 'code': '+213', 'flag': '🇩🇿'},
    {'name': 'Argentina', 'code': '+54', 'flag': '🇦🇷'},
    {'name': 'Armenia', 'code': '+374', 'flag': '🇦🇲'},
    {'name': 'Australia', 'code': '+61', 'flag': '🇦🇺'},
    {'name': 'Austria', 'code': '+43', 'flag': '🇦🇹'},
    {'name': 'Azerbaijan', 'code': '+994', 'flag': '🇦🇿'},
    {'name': 'Bahrain', 'code': '+973', 'flag': '🇧🇭'},
    {'name': 'Bangladesh', 'code': '+880', 'flag': '🇧🇩'},
    {'name': 'Belarus', 'code': '+375', 'flag': '🇧🇾'},
    {'name': 'Belgium', 'code': '+32', 'flag': '🇧🇪'},
    {'name': 'Bolivia', 'code': '+591', 'flag': '🇧🇴'},
    {'name': 'Brazil', 'code': '+55', 'flag': '🇧🇷'},
    {'name': 'Bulgaria', 'code': '+359', 'flag': '🇧🇬'},
    {'name': 'Cambodia', 'code': '+855', 'flag': '🇰🇭'},
    {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
    {'name': 'Chile', 'code': '+56', 'flag': '🇨🇱'},
    {'name': 'China', 'code': '+86', 'flag': '🇨🇳'},
    {'name': 'Colombia', 'code': '+57', 'flag': '🇨🇴'},
    {'name': 'Croatia', 'code': '+385', 'flag': '🇭🇷'},
    {'name': 'Czech Republic', 'code': '+420', 'flag': '🇨🇿'},
    {'name': 'Denmark', 'code': '+45', 'flag': '🇩🇰'},
    {'name': 'Ecuador', 'code': '+593', 'flag': '🇪🇨'},
    {'name': 'Egypt', 'code': '+20', 'flag': '🇪🇬'},
    {'name': 'Estonia', 'code': '+372', 'flag': '🇪🇪'},
    {'name': 'Ethiopia', 'code': '+251', 'flag': '🇪🇹'},
    {'name': 'Finland', 'code': '+358', 'flag': '🇫🇮'},
    {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
    {'name': 'Georgia', 'code': '+995', 'flag': '🇬🇪'},
    {'name': 'Germany', 'code': '+49', 'flag': '🇩🇪'},
    {'name': 'Ghana', 'code': '+233', 'flag': '🇬🇭'},
    {'name': 'Greece', 'code': '+30', 'flag': '🇬🇷'},
    {'name': 'Hong Kong', 'code': '+852', 'flag': '🇭🇰'},
    {'name': 'Hungary', 'code': '+36', 'flag': '🇭🇺'},
    {'name': 'Iceland', 'code': '+354', 'flag': '🇮🇸'},
    {'name': 'India', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'Indonesia', 'code': '+62', 'flag': '🇮🇩'},
    {'name': 'Iran', 'code': '+98', 'flag': '🇮🇷'},
    {'name': 'Iraq', 'code': '+964', 'flag': '🇮🇶'},
    {'name': 'Ireland', 'code': '+353', 'flag': '🇮🇪'},
    {'name': 'Israel', 'code': '+972', 'flag': '🇮🇱'},
    {'name': 'Italy', 'code': '+39', 'flag': '🇮🇹'},
    {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'Jordan', 'code': '+962', 'flag': '🇯🇴'},
    {'name': 'Kazakhstan', 'code': '+7', 'flag': '🇰🇿'},
    {'name': 'Kenya', 'code': '+254', 'flag': '🇰🇪'},
    {'name': 'Kuwait', 'code': '+965', 'flag': '🇰🇼'},
    {'name': 'Latvia', 'code': '+371', 'flag': '🇱🇻'},
    {'name': 'Lebanon', 'code': '+961', 'flag': '🇱🇧'},
    {'name': 'Lithuania', 'code': '+370', 'flag': '🇱🇹'},
    {'name': 'Luxembourg', 'code': '+352', 'flag': '🇱🇺'},
    {'name': 'Macao', 'code': '+853', 'flag': '🇲🇴'},
    {'name': 'Malaysia', 'code': '+60', 'flag': '🇲🇾'},
    {'name': 'Mexico', 'code': '+52', 'flag': '🇲🇽'},
    {'name': 'Morocco', 'code': '+212', 'flag': '🇲🇦'},
    {'name': 'Netherlands', 'code': '+31', 'flag': '🇳🇱'},
    {'name': 'New Zealand', 'code': '+64', 'flag': '🇳🇿'},
    {'name': 'Nigeria', 'code': '+234', 'flag': '🇳🇬'},
    {'name': 'Norway', 'code': '+47', 'flag': '🇳🇴'},
    {'name': 'Pakistan', 'code': '+92', 'flag': '🇵🇰'},
    {'name': 'Peru', 'code': '+51', 'flag': '🇵🇪'},
    {'name': 'Philippines', 'code': '+63', 'flag': '🇵🇭'},
    {'name': 'Poland', 'code': '+48', 'flag': '🇵🇱'},
    {'name': 'Portugal', 'code': '+351', 'flag': '🇵🇹'},
    {'name': 'Qatar', 'code': '+974', 'flag': '🇶🇦'},
    {'name': 'Romania', 'code': '+40', 'flag': '🇷🇴'},
    {'name': 'Russia', 'code': '+7', 'flag': '🇷🇺'},
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦'},
    {'name': 'Singapore', 'code': '+65', 'flag': '🇸🇬'},
    {'name': 'Slovakia', 'code': '+421', 'flag': '🇸🇰'},
    {'name': 'Slovenia', 'code': '+386', 'flag': '🇸🇮'},
    {'name': 'South Africa', 'code': '+27', 'flag': '🇿🇦'},
    {'name': 'South Korea', 'code': '+82', 'flag': '🇰🇷'},
    {'name': 'Spain', 'code': '+34', 'flag': '🇪🇸'},
    {'name': 'Sri Lanka', 'code': '+94', 'flag': '🇱🇰'},
    {'name': 'Sweden', 'code': '+46', 'flag': '🇸🇪'},
    {'name': 'Switzerland', 'code': '+41', 'flag': '🇨🇭'},
    {'name': 'Taiwan', 'code': '+886', 'flag': '🏝️'},
    {'name': 'Thailand', 'code': '+66', 'flag': '🇹🇭'},
    {'name': 'Turkey', 'code': '+90', 'flag': '🇹🇷'},
    {'name': 'Ukraine', 'code': '+380', 'flag': '🇺🇦'},
    {'name': 'United Arab Emirates', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧'},
    {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
    {'name': 'Uruguay', 'code': '+598', 'flag': '🇺🇾'},
    {'name': 'Venezuela', 'code': '+58', 'flag': '🇻🇪'},
    {'name': 'Vietnam', 'code': '+84', 'flag': '🇻🇳'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: isDark
          ? CupertinoColors.systemBackground.resolveFrom(context)
          : Color(0xFFF2F2F7),
      child: GestureDetector(
        onTap: () {
          // 点击空白区域收回键盘
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),

                // 主标题
                Text(
                  'Get started with your phone number',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: CupertinoColors.label.resolveFrom(context),
                    height: 1.2,
                  ),
                ),

                SizedBox(height: 12),

                // 副标题说明
                Text(
                  'New here? We\'ll create your account and send a code to verify your number.',
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 50),

                // 手机号输入框
                Container(
                  decoration: BoxDecoration(
                    color: isDark
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
                      // 国家代码选择器
                      GestureDetector(
                        onTap: () => _showCountryPicker(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: CupertinoColors.systemGrey5
                                    .resolveFrom(context)
                                    .withOpacity(0.5),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedCountryFlag,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(width: 8),
                              Text(
                                _selectedCountryCode,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: CupertinoColors.label.resolveFrom(
                                    context,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                CupertinoIcons.chevron_down,
                                color: CupertinoColors.systemGrey.resolveFrom(
                                  context,
                                ),
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 手机号输入框
                      Expanded(
                        child: CupertinoTextField(
                          controller: _phoneController,
                          placeholder: '123 456 7890',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          decoration: BoxDecoration(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                          placeholderStyle: TextStyle(
                            color: CupertinoColors.placeholderText.resolveFrom(
                              context,
                            ),
                            fontSize: 17,
                          ),
                          onChanged: (value) => setState(() {}),
                          onSubmitted: (_) => {},
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                // Continue 按钮
                Container(
                  width: double.infinity,
                  height: 50,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    color: _canLogin()
                        ? CupertinoColors.systemBlue.resolveFrom(context)
                        : CupertinoColors.systemGrey4.resolveFrom(context),
                    borderRadius: BorderRadius.circular(12),
                    onPressed: _canLogin() && !_isLoading
                        ? _performLogin
                        : null,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _isLoading
                          ? CupertinoActivityIndicator(
                              key: ValueKey('loading'),
                              color: CupertinoColors.white,
                              radius: 10,
                            )
                          : Text(
                              key: ValueKey('text'),
                              'Continue',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _canLogin() {
    return _phoneController.text.trim().isNotEmpty;
  }

  void _performLogin() async {
    if (!_canLogin() || _isLoading) return;

    setState(() => _isLoading = true);

    // 触觉反馈
    HapticFeedback.lightImpact();

    try {
      // 模拟发送验证码过程
      await Future.delayed(Duration(seconds: 1));

      if (mounted) {
        // 跳转到验证码页面
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => VerificationCodePage(
              phoneNumber:
                  '$_selectedCountryCode ${_phoneController.text.trim()}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to send verification code. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showCountryPicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'Select Country',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label.resolveFrom(context),
          ),
        ),
        actions: _countries
            .map(
              (country) => CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _selectedCountryCode = country['code']!;
                    _selectedCountryName = country['name']!;
                    _selectedCountryFlag = country['flag']!;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        alignment: Alignment.center,
                        child: Text(
                          country['flag']!,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          country['name']!,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text(
                        country['code']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.systemGrey.resolveFrom(
                            context,
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemBlue.resolveFrom(context),
            ),
          ),
        ),
      ),
    );
  }
}

class VerificationCodePage extends StatefulWidget {
  final String phoneNumber;

  const VerificationCodePage({super.key, required this.phoneNumber});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: isDark
          ? CupertinoColors.systemBackground.resolveFrom(context)
          : Color(0xFFF2F2F7),
      child: GestureDetector(
        onTap: () {
          // 点击空白区域收回键盘
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              // 返回按钮
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(
                    CupertinoIcons.back,
                    color: CupertinoColors.label.resolveFrom(context),
                    size: 28,
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),

                      // 主标题
                      Text(
                        'Enter verification code',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: CupertinoColors.label.resolveFrom(context),
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: 12),

                      // 副标题说明
                      Text(
                        'We sent a 6-digit code to ${widget.phoneNumber}. Enter it below to verify your phone number.',
                        style: TextStyle(
                          fontSize: 15,
                          color: CupertinoColors.secondaryLabel.resolveFrom(
                            context,
                          ),
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: 50),

                      // 验证码输入框
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
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
                        child: CupertinoTextField(
                          controller: _codeController,
                          placeholder: '123456',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: BoxDecoration(),
                          padding: EdgeInsets.zero,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 4,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                          placeholderStyle: TextStyle(
                            color: CupertinoColors.placeholderText.resolveFrom(
                              context,
                            ),
                            fontSize: 24,
                            letterSpacing: 4,
                          ),
                          onChanged: (value) => setState(() {}),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          autofocus: true,
                        ),
                      ),

                      SizedBox(height: 24),

                      // 重新发送按钮
                      Center(
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _resendCode(),
                          child: Text(
                            'Resend code',
                            style: TextStyle(
                              fontSize: 15,
                              color: CupertinoColors.systemBlue.resolveFrom(
                                context,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 40),

                      // Verify 按钮
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          color: _canVerify()
                              ? CupertinoColors.systemBlue.resolveFrom(context)
                              : CupertinoColors.systemGrey4.resolveFrom(
                                  context,
                                ),
                          borderRadius: BorderRadius.circular(12),
                          onPressed: _canVerify() && !_isLoading
                              ? _performVerification
                              : null,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: _isLoading
                                ? CupertinoActivityIndicator(
                                    key: ValueKey('loading'),
                                    color: CupertinoColors.white,
                                    radius: 10,
                                  )
                                : Text(
                                    key: ValueKey('text'),
                                    'Verify',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: CupertinoColors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canVerify() {
    return _codeController.text.trim().length == 6;
  }

  void _resendCode() {
    HapticFeedback.lightImpact();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Code Sent'),
        content: Text(
          'A new verification code has been sent to ${widget.phoneNumber}.',
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _performVerification() async {
    if (!_canVerify() || _isLoading) return;

    setState(() => _isLoading = true);

    // 触觉反馈
    HapticFeedback.lightImpact();

    try {
      // 模拟验证过程
      await Future.delayed(Duration(seconds: 1));

      if (mounted) {
        // 验证成功，跳转到主页面
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => MyApp()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Invalid verification code. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Error'),
        content: Text(message),
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
