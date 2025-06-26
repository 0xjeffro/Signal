import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../main.dart';

class LoginVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const LoginVerificationPage({super.key, required this.phoneNumber});

  @override
  State<LoginVerificationPage> createState() => _LoginVerificationPageState();
}

class _LoginVerificationPageState extends State<LoginVerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  bool _isLoading = false;
  Timer? _resendTimer;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    // 页面加载时开始倒计时
    _startResendCountdown();

    // 确保焦点始终在验证码输入框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocusNode.requestFocus();
    });

    // 监听焦点变化，确保键盘始终显示
    _codeFocusNode.addListener(() {
      if (!_codeFocusNode.hasFocus && !_isLoading) {
        // 如果失去焦点且不在验证过程中，重新获取焦点
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted && !_isLoading) {
            _codeFocusNode.requestFocus();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    _resendTimer?.cancel();
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
          // 点击空白区域确保焦点在验证码输入框
          _codeFocusNode.requestFocus();
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
                          focusNode: _codeFocusNode,
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
                          onTap: () {
                            // 确保点击输入框时焦点在这里
                            _codeFocusNode.requestFocus();
                          },
                        ),
                      ),

                      SizedBox(height: 24),

                      // 重新发送按钮
                      Center(
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _resendCountdown == 0
                              ? () => _resendCode()
                              : null,
                          child: Text(
                            _resendCountdown == 0
                                ? 'Resend code'
                                : 'Resend code (${_resendCountdown.toString().padLeft(2, '0')}s)',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Courier', // 使用等宽字体
                              letterSpacing: -0.3, // 稍微紧凑一些
                              color: _resendCountdown == 0
                                  ? CupertinoColors.systemBlue.resolveFrom(
                                      context,
                                    )
                                  : CupertinoColors.systemGrey.resolveFrom(
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

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 60; // 60秒倒计时
    });

    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _resendCode() {
    HapticFeedback.lightImpact();

    // 重新开始倒计时
    _startResendCountdown();

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
        // 先收起键盘
        _codeFocusNode.unfocus();
        FocusScope.of(context).unfocus();

        // 等待键盘收起动画完成后再跳转
        await Future.delayed(Duration(milliseconds: 300));

        if (mounted) {
          // 验证成功，跳转到主页面
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => MyApp()),
            (route) => false,
          );
        }
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
