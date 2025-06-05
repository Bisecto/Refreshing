// lib/screens/auth/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/view/widgets/loading_animation.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../res/app_colors.dart';
import '../../utills/app_navigator.dart';
import '../../utills/app_validator.dart';
import '../widgets/app_custom_text.dart';
import '../widgets/form_button.dart';
import '../widgets/form_input.dart';
import 'otp_verification.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      context.read<AuthBloc>().add(
        SignUpRequested(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
            AppNavigator.pushAndStackPage(
              context,
              page: OTPVerificationScreen(email: state.email),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              TextStyles.textHeadings(
                                textValue: "Sign Up",
                                textColor: AppColors.black,
                                textSize: 30,
                              ),
                              const SizedBox(height: 20),
                              const CustomText(
                                text:
                                    'Create your account to get started with our amazing features.',
                                size: 16,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                color: AppColors.textColor,
                              ),
                              const SizedBox(height: 30),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    CustomTextFormField(
                                      hint: 'Username',
                                      label: '',
                                      controller: _usernameController,
                                      borderColor:
                                          AppColors
                                              .textFormFieldBackgroundColor,
                                      backgroundColor:
                                          AppColors
                                              .textFormFieldBackgroundColor,
                                      validator: AppValidator.validateTextfield,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormField(
                                      hint: 'Email',
                                      label: '',
                                      controller: _emailController,
                                      //keyboardType: TextInputType.emailAddress,
                                      borderColor:
                                          AppColors
                                              .textFormFieldBackgroundColor,
                                      backgroundColor:
                                          AppColors
                                              .textFormFieldBackgroundColor,
                                      validator: _validateEmail,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormField(
                                      label: '',
                                      isPasswordField: true,
                                      backgroundColor:
                                          AppColors
                                              .textFormFieldBackgroundColor,
                                      validator: _validatePassword,
                                      controller: _passwordController,
                                      hint: 'Password',
                                      borderColor:
                                          AppColors
                                              .textFormFieldBackgroundColor,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormField(
                                      label: '',
                                      isPasswordField: true,
                                      backgroundColor:
                                          AppColors
                                              .textFormFieldBackgroundColor,
                                      validator: _validateConfirmPassword,
                                      controller: _confirmPasswordController,
                                      hint: 'Confirm Password',
                                      borderColor:
                                          AppColors
                                              .textFormFieldBackgroundColor,
                                    ),
                                    const SizedBox(height: 20),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text:
                                            'By creating an account, you agree to our ',
                                        style: TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Terms of Service',
                                            style: TextStyle(
                                              color: AppColors.blue,
                                              fontWeight: FontWeight.w500,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          const TextSpan(text: ' and '),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: TextStyle(
                                              color: AppColors.blue,
                                              fontWeight: FontWeight.w500,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    FormButton(
                                      onPressed: _handleSignUp,
                                      text: 'Create Account',
                                      borderColor: AppColors.appMainColor,
                                      bgColor: AppColors.appMainColor,
                                      textColor: AppColors.white,
                                      borderRadius: 12,
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Divider(
                                      color:
                                          AppColors
                                              .textFormFieldBackgroundColor,
                                    ),
                                  ),
                                  Text("  OR  "),
                                  Expanded(
                                    child: Divider(
                                      color:
                                          AppColors
                                              .textFormFieldBackgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SocialLoginButton(
                                buttonType: SocialLoginButtonType.google,
                                onPressed: () {
                                  // Handle Google sign up
                                },
                                imageWidth: 30,
                                borderRadius: 12,
                                backgroundColor:
                                    AppColors.textFormFieldBackgroundColor,
                              ),
                              const SizedBox(height: 12),
                              SocialLoginButton(
                                buttonType: SocialLoginButtonType.apple,
                                onPressed: () {
                                  // Handle Apple sign up
                                },
                                borderRadius: 12,
                                imageWidth: 30,
                                backgroundColor:
                                    AppColors.textFormFieldBackgroundColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: GestureDetector(
                            onTap: () {
                              AppNavigator.pushAndRemovePreviousPages(
                                context,
                                page: const SignInScreen(),
                              );
                            },
                            child: TextStyles.richTexts(
                              text1: 'Already have an account? ',
                              text2: "Sign In",
                              size: 14,
                              weight: FontWeight.w600,
                              color2: AppColors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is AuthLoading)
                  const LoadingDialog(("Loading please wait..")),
              ],
            );
          },
        ),
      ),
    );
  }
}
