import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:refreshing_co/view/app_screens/landing_page.dart';
import 'package:refreshing_co/view/widgets/loading_animation.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../res/app_colors.dart';
import '../../utills/app_navigator.dart';
import '../app_screens/home_screen.dart';
import '../widgets/app_custom_text.dart';
import '../widgets/form_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  Timer? _timer;
  int _remainingTime = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 60;
    _canResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  String _getOTP() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  bool _isOTPComplete() {
    return _getOTP().length == 6;
  }

  void _handleVerifyOTP() {
    if (_isOTPComplete()) {
      FocusScope.of(context).unfocus();

      context.read<AuthBloc>().add(
        VerifyOTPRequested(
          email: widget.email,
          otp: _getOTP(),
        ),
      );
    }
  }

  void _handleResendOTP() {
    if (_canResend) {
      context.read<AuthBloc>().add(
        ResendOTPRequested(email: widget.email),
      );
      _startTimer();
    }
  }

  void _onOTPChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto verify when all fields are filled
    if (_isOTPComplete()) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleVerifyOTP();
      });
    }
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 50,
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.textFormFieldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? AppColors.appMainColor
              : AppColors.textFormFieldBackgroundColor,
          width: 2,
        ),
      ),
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) => _onOTPChanged(value, index),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verify Email',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOTPVerificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to home or dashboard
            AppNavigator.pushAndRemovePreviousPages(
              context,
              page:  LandingPage(selectedIndex: 0),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthSignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Icon(
                          Icons.email_outlined,
                          size: 80,
                          color: AppColors.appMainColor,
                        ),
                        const SizedBox(height: 30),
                        TextStyles.textHeadings(
                          textValue: "Verify Your Email",
                          textColor: AppColors.black,
                          textSize: 28,
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          text: 'We\'ve sent a 6-digit verification code to',
                          size: 16,
                          color: AppColors.textColor,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.email,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appMainColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) => _buildOTPField(index)),
                        ),
                        const SizedBox(height: 40),
                        FormButton(
                          onPressed: //_isOTPComplete() ?
                          _handleVerifyOTP,
                              //: null,
                          text: 'Verify OTP',
                          borderColor: _isOTPComplete()
                              ? AppColors.appMainColor
                              : AppColors.textFormFieldBackgroundColor,
                          bgColor: _isOTPComplete()
                              ? AppColors.appMainColor
                              : AppColors.textFormFieldBackgroundColor,
                          textColor: _isOTPComplete()
                              ? AppColors.white
                              : AppColors.textColor,
                          borderRadius: 12,
                          height: 50,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't receive the code? ",
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: _canResend ? _handleResendOTP : null,
                              child: Text(
                                _canResend ? 'Resend' : 'Resend in ${_formatTime(_remainingTime)}',
                                style: TextStyle(
                                  color: _canResend ? AppColors.blue : AppColors.textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: _canResend ? TextDecoration.underline : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.textFormFieldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Check your spam folder if you don\'t see the email in your inbox.',
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                if (state is AuthLoading) const LoadingDialog(("Loading....")),
              ],
            );
          },
        ),
      ),
    );
  }
}