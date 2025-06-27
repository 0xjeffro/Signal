import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'login_verification_page.dart';

// 自定义手机号格式化器
class PhoneNumberFormatter extends TextInputFormatter {
  final String format;

  PhoneNumberFormatter(this.format);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 只保留数字
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // 限制最大长度为格式中的数字个数
    String formatDigitsOnly = format.replaceAll(' ', '');
    if (digitsOnly.length > formatDigitsOnly.length) {
      digitsOnly = digitsOnly.substring(0, formatDigitsOnly.length);
    }

    // 根据格式添加空格
    String formatted = _applyFormat(digitsOnly, format);

    // 计算光标位置
    int cursorPosition = _calculateCursorPosition(
      oldValue.text,
      newValue.text,
      formatted,
      newValue.selection.baseOffset,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  String _applyFormat(String digits, String format) {
    if (digits.isEmpty) return '';

    String result = '';
    int digitIndex = 0;

    for (int i = 0; i < format.length && digitIndex < digits.length; i++) {
      if (format[i] == ' ') {
        result += ' ';
      } else {
        result += digits[digitIndex];
        digitIndex++;
      }
    }

    return result;
  }

  int _calculateCursorPosition(
    String oldText,
    String newText,
    String formattedText,
    int originalCursor,
  ) {
    // 简单处理：将光标放在格式化文本的末尾
    return formattedText.length;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isLoading = false;

  // 国家代码相关
  String _selectedCountryCode = '+1';
  String _selectedCountryName = 'United States';
  String _selectedCountryFlag = '🇺🇸';

  // 常用国家列表
  final List<Map<String, String>> _countries = [
    {
      'name': 'Afghanistan',
      'code': '+93',
      'flag': '🇦🇫',
      'placeholder': '701 234 567',
    },
    {
      'name': 'Albania',
      'code': '+355',
      'flag': '🇦🇱',
      'placeholder': '67 212 3456',
    },
    {
      'name': 'Algeria',
      'code': '+213',
      'flag': '🇩🇿',
      'placeholder': '551 234 567',
    },
    {
      'name': 'Argentina',
      'code': '+54',
      'flag': '🇦🇷',
      'placeholder': '11 1234 5678',
    },
    {
      'name': 'Armenia',
      'code': '+374',
      'flag': '🇦🇲',
      'placeholder': '77 123456',
    },
    {
      'name': 'Australia',
      'code': '+61',
      'flag': '🇦🇺',
      'placeholder': '412 345 678',
    },
    {
      'name': 'Austria',
      'code': '+43',
      'flag': '🇦🇹',
      'placeholder': '664 123456',
    },
    {
      'name': 'Azerbaijan',
      'code': '+994',
      'flag': '🇦🇿',
      'placeholder': '40 123 45 67',
    },
    {
      'name': 'Bahrain',
      'code': '+973',
      'flag': '🇧🇭',
      'placeholder': '3600 1234',
    },
    {
      'name': 'Bangladesh',
      'code': '+880',
      'flag': '🇧🇩',
      'placeholder': '1812 345678',
    },
    {
      'name': 'Belarus',
      'code': '+375',
      'flag': '🇧🇾',
      'placeholder': '29 123 45 67',
    },
    {
      'name': 'Belgium',
      'code': '+32',
      'flag': '🇧🇪',
      'placeholder': '470 12 34 56',
    },
    {
      'name': 'Bolivia',
      'code': '+591',
      'flag': '🇧🇴',
      'placeholder': '71234567',
    },
    {
      'name': 'Brazil',
      'code': '+55',
      'flag': '🇧🇷',
      'placeholder': '11 91234 5678',
    },
    {
      'name': 'Bulgaria',
      'code': '+359',
      'flag': '🇧🇬',
      'placeholder': '87 123 4567',
    },
    {
      'name': 'Cambodia',
      'code': '+855',
      'flag': '🇰🇭',
      'placeholder': '91 234 567',
    },
    {
      'name': 'Canada',
      'code': '+1',
      'flag': '🇨🇦',
      'placeholder': '234 567 8901',
    },
    {
      'name': 'Chile',
      'code': '+56',
      'flag': '🇨🇱',
      'placeholder': '9 1234 5678',
    },
    {
      'name': 'China',
      'code': '+86',
      'flag': '🇨🇳',
      'placeholder': '131 2345 6789',
    },
    {
      'name': 'Colombia',
      'code': '+57',
      'flag': '🇨🇴',
      'placeholder': '321 1234567',
    },
    {
      'name': 'Croatia',
      'code': '+385',
      'flag': '🇭🇷',
      'placeholder': '91 234 567',
    },
    {
      'name': 'Czech Republic',
      'code': '+420',
      'flag': '🇨🇿',
      'placeholder': '601 123 456',
    },
    {
      'name': 'Denmark',
      'code': '+45',
      'flag': '🇩🇰',
      'placeholder': '20 12 34 56',
    },
    {
      'name': 'Ecuador',
      'code': '+593',
      'flag': '🇪🇨',
      'placeholder': '99 123 4567',
    },
    {
      'name': 'Egypt',
      'code': '+20',
      'flag': '🇪🇬',
      'placeholder': '100 123 4567',
    },
    {
      'name': 'Estonia',
      'code': '+372',
      'flag': '🇪🇪',
      'placeholder': '5123 4567',
    },
    {
      'name': 'Ethiopia',
      'code': '+251',
      'flag': '🇪🇹',
      'placeholder': '91 123 4567',
    },
    {
      'name': 'Finland',
      'code': '+358',
      'flag': '🇫🇮',
      'placeholder': '41 234 5678',
    },
    {
      'name': 'France',
      'code': '+33',
      'flag': '🇫🇷',
      'placeholder': '6 12 34 56 78',
    },
    {
      'name': 'Georgia',
      'code': '+995',
      'flag': '🇬🇪',
      'placeholder': '555 12 34 56',
    },
    {
      'name': 'Germany',
      'code': '+49',
      'flag': '🇩🇪',
      'placeholder': '151 12345678',
    },
    {
      'name': 'Ghana',
      'code': '+233',
      'flag': '🇬🇭',
      'placeholder': '23 123 4567',
    },
    {
      'name': 'Greece',
      'code': '+30',
      'flag': '🇬🇷',
      'placeholder': '691 234 5678',
    },
    {
      'name': 'Hong Kong',
      'code': '+852',
      'flag': '🇭🇰',
      'placeholder': '5123 4567',
    },
    {
      'name': 'Hungary',
      'code': '+36',
      'flag': '🇭🇺',
      'placeholder': '20 123 4567',
    },
    {
      'name': 'Iceland',
      'code': '+354',
      'flag': '🇮🇸',
      'placeholder': '611 1234',
    },
    {
      'name': 'India',
      'code': '+91',
      'flag': '🇮🇳',
      'placeholder': '81234 56789',
    },
    {
      'name': 'Indonesia',
      'code': '+62',
      'flag': '🇮🇩',
      'placeholder': '812 345 678',
    },
    {
      'name': 'Iran',
      'code': '+98',
      'flag': '🇮🇷',
      'placeholder': '912 345 6789',
    },
    {
      'name': 'Iraq',
      'code': '+964',
      'flag': '🇮🇶',
      'placeholder': '791 234 5678',
    },
    {
      'name': 'Ireland',
      'code': '+353',
      'flag': '🇮🇪',
      'placeholder': '85 123 4567',
    },
    {
      'name': 'Israel',
      'code': '+972',
      'flag': '🇮🇱',
      'placeholder': '50 123 4567',
    },
    {
      'name': 'Italy',
      'code': '+39',
      'flag': '🇮🇹',
      'placeholder': '320 123 4567',
    },
    {
      'name': 'Japan',
      'code': '+81',
      'flag': '🇯🇵',
      'placeholder': '80 1234 5678',
    },
    {
      'name': 'Jordan',
      'code': '+962',
      'flag': '🇯🇴',
      'placeholder': '7 9012 3456',
    },
    {
      'name': 'Kazakhstan',
      'code': '+7',
      'flag': '🇰🇿',
      'placeholder': '701 234 5678',
    },
    {
      'name': 'Kenya',
      'code': '+254',
      'flag': '🇰🇪',
      'placeholder': '712 345678',
    },
    {
      'name': 'Kuwait',
      'code': '+965',
      'flag': '🇰🇼',
      'placeholder': '5123 4567',
    },
    {
      'name': 'Latvia',
      'code': '+371',
      'flag': '🇱🇻',
      'placeholder': '2123 4567',
    },
    {
      'name': 'Lebanon',
      'code': '+961',
      'flag': '🇱🇧',
      'placeholder': '71 123 456',
    },
    {
      'name': 'Lithuania',
      'code': '+370',
      'flag': '🇱🇹',
      'placeholder': '612 34567',
    },
    {
      'name': 'Luxembourg',
      'code': '+352',
      'flag': '🇱🇺',
      'placeholder': '628 123 456',
    },
    {
      'name': 'Macao',
      'code': '+853',
      'flag': '🇲🇴',
      'placeholder': '6612 3456',
    },
    {
      'name': 'Malaysia',
      'code': '+60',
      'flag': '🇲🇾',
      'placeholder': '12 345 6789',
    },
    {
      'name': 'Mexico',
      'code': '+52',
      'flag': '🇲🇽',
      'placeholder': '55 1234 5678',
    },
    {
      'name': 'Morocco',
      'code': '+212',
      'flag': '🇲🇦',
      'placeholder': '650 123456',
    },
    {
      'name': 'Netherlands',
      'code': '+31',
      'flag': '🇳🇱',
      'placeholder': '6 12345678',
    },
    {
      'name': 'New Zealand',
      'code': '+64',
      'flag': '🇳🇿',
      'placeholder': '21 123 4567',
    },
    {
      'name': 'Nigeria',
      'code': '+234',
      'flag': '🇳🇬',
      'placeholder': '802 123 4567',
    },
    {
      'name': 'Norway',
      'code': '+47',
      'flag': '🇳🇴',
      'placeholder': '406 12 345',
    },
    {
      'name': 'Pakistan',
      'code': '+92',
      'flag': '🇵🇰',
      'placeholder': '301 2345678',
    },
    {
      'name': 'Peru',
      'code': '+51',
      'flag': '🇵🇪',
      'placeholder': '912 345 678',
    },
    {
      'name': 'Philippines',
      'code': '+63',
      'flag': '🇵🇭',
      'placeholder': '917 123 4567',
    },
    {
      'name': 'Poland',
      'code': '+48',
      'flag': '🇵🇱',
      'placeholder': '512 345 678',
    },
    {
      'name': 'Portugal',
      'code': '+351',
      'flag': '🇵🇹',
      'placeholder': '912 345 678',
    },
    {
      'name': 'Qatar',
      'code': '+974',
      'flag': '🇶🇦',
      'placeholder': '3312 3456',
    },
    {
      'name': 'Romania',
      'code': '+40',
      'flag': '🇷🇴',
      'placeholder': '712 345 678',
    },
    {
      'name': 'Russia',
      'code': '+7',
      'flag': '🇷🇺',
      'placeholder': '912 345 6789',
    },
    {
      'name': 'Saudi Arabia',
      'code': '+966',
      'flag': '🇸🇦',
      'placeholder': '50 123 4567',
    },
    {
      'name': 'Singapore',
      'code': '+65',
      'flag': '🇸🇬',
      'placeholder': '8123 4567',
    },
    {
      'name': 'Slovakia',
      'code': '+421',
      'flag': '🇸🇰',
      'placeholder': '912 345 678',
    },
    {
      'name': 'Slovenia',
      'code': '+386',
      'flag': '🇸🇮',
      'placeholder': '31 234 567',
    },
    {
      'name': 'South Africa',
      'code': '+27',
      'flag': '🇿🇦',
      'placeholder': '82 123 4567',
    },
    {
      'name': 'South Korea',
      'code': '+82',
      'flag': '🇰🇷',
      'placeholder': '10 1234 5678',
    },
    {
      'name': 'Spain',
      'code': '+34',
      'flag': '🇪🇸',
      'placeholder': '612 34 56 78',
    },
    {
      'name': 'Sri Lanka',
      'code': '+94',
      'flag': '🇱🇰',
      'placeholder': '71 234 5678',
    },
    {
      'name': 'Sweden',
      'code': '+46',
      'flag': '🇸🇪',
      'placeholder': '70 123 45 67',
    },
    {
      'name': 'Switzerland',
      'code': '+41',
      'flag': '🇨🇭',
      'placeholder': '78 123 45 67',
    },
    {
      'name': 'Taiwan',
      'code': '+886',
      'flag': '🏝️',
      'placeholder': '912 345 678',
    },
    {
      'name': 'Thailand',
      'code': '+66',
      'flag': '🇹🇭',
      'placeholder': '81 234 5678',
    },
    {
      'name': 'Turkey',
      'code': '+90',
      'flag': '🇹🇷',
      'placeholder': '532 123 45 67',
    },
    {
      'name': 'Ukraine',
      'code': '+380',
      'flag': '🇺🇦',
      'placeholder': '50 123 4567',
    },
    {
      'name': 'United Arab Emirates',
      'code': '+971',
      'flag': '🇦🇪',
      'placeholder': '50 123 4567',
    },
    {
      'name': 'United Kingdom',
      'code': '+44',
      'flag': '🇬🇧',
      'placeholder': '7400 123456',
    },
    {
      'name': 'United States',
      'code': '+1',
      'flag': '🇺🇸',
      'placeholder': '201 555 0123',
    },
    {
      'name': 'Uruguay',
      'code': '+598',
      'flag': '🇺🇾',
      'placeholder': '94 123 456',
    },
    {
      'name': 'Venezuela',
      'code': '+58',
      'flag': '🇻🇪',
      'placeholder': '412 1234567',
    },
    {
      'name': 'Vietnam',
      'code': '+84',
      'flag': '🇻🇳',
      'placeholder': '912 345 678',
    },
  ];

  // 获取当前选择国家的手机号格式
  String get _currentPlaceholder {
    final country = _countries.firstWhere(
      (country) => country['code'] == _selectedCountryCode,
      orElse: () => _countries.first,
    );
    return country['placeholder'] ?? '123 456 7890';
  }

  // 构建动态placeholder，只显示未输入的部分
  Widget _buildDynamicPlaceholder(BuildContext context) {
    String currentText = _phoneController.text;
    String fullPlaceholder = _currentPlaceholder;

    // 计算已输入的数字个数
    String digitsOnly = currentText.replaceAll(' ', '');
    String placeholderDigitsOnly = fullPlaceholder.replaceAll(' ', '');

    if (digitsOnly.length >= placeholderDigitsOnly.length) {
      return SizedBox(); // 输入完整，不显示placeholder
    }

    // 始终使用RichText来避免组件切换导致的跳动
    List<TextSpan> spans = [];
    int digitIndex = 0;
    int inputDigitIndex = 0;

    for (int i = 0; i < fullPlaceholder.length; i++) {
      if (fullPlaceholder[i] == ' ') {
        spans.add(TextSpan(text: ' '));
      } else {
        if (inputDigitIndex < digitsOnly.length) {
          // 已输入的位置用输入框背景色占位，实现真正的透明效果
          spans.add(
            TextSpan(
              text: fullPlaceholder[i],
              style: TextStyle(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? CupertinoColors.systemGrey6.resolveFrom(context)
                    : CupertinoColors.white,
              ),
            ),
          );
          inputDigitIndex++;
        } else {
          // 未输入的位置显示placeholder
          spans.add(
            TextSpan(
              text: placeholderDigitsOnly[digitIndex],
              style: TextStyle(
                color: CupertinoColors.placeholderText.resolveFrom(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
        digitIndex++;
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Courier', // 使用Courier等宽字体
          height: 1.0, // 确保行高一致
        ),
        children: spans,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 页面加载完成后自动聚焦到手机号输入框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
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
                    fontSize: 15,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    height: 1.4,
                    fontWeight: FontWeight.w400,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedCountryFlag,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(width: 8),
                              Text(
                                _selectedCountryCode,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.label.resolveFrom(
                                    context,
                                  ),
                                  height: 1.0,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                CupertinoIcons.chevron_down,
                                color: CupertinoColors.systemGrey.resolveFrom(
                                  context,
                                ),
                                size: 13,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 手机号输入框
                      Expanded(
                        child: Stack(
                          children: [
                            // 动态placeholder背景
                            Positioned.fill(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: _buildDynamicPlaceholder(context),
                              ),
                            ),
                            // 实际输入框
                            CupertinoTextField(
                              controller: _phoneController,
                              focusNode: _phoneFocusNode,
                              placeholder: '', // 隐藏默认placeholder
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                PhoneNumberFormatter(_currentPlaceholder),
                              ],
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Courier', // 使用Courier等宽字体
                                color: CupertinoColors.label.resolveFrom(
                                  context,
                                ),
                              ),
                              onChanged: (value) => setState(() {}),
                              onSubmitted: (_) => {},
                            ),
                          ],
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
            builder: (context) => LoginVerificationPage(
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
                    // 清空输入框以应用新的格式
                    _phoneController.clear();
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
