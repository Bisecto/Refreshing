import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/view/app_screens/landing_page.dart';
import 'package:refreshing_co/view/auth/reset_password_screen.dart';
import 'package:refreshing_co/view/auth/sign_up_screen.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../../utills/app_validator.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../widgets/app_custom_text.dart';
import '../widgets/form_button.dart';
import '../widgets/form_input.dart';
import '../widgets/loading_animation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    // TODO: implement initState
    //authBloc.add(InitialEvent());
    //AppUtils().logout(context);

    super.initState();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      context.read<AuthBloc>().add(
        SignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSignInSuccess) {
            print(state.token);
            print(state.placemark);
            print(state.position);
            AppNavigator.pushAndRemovePreviousPages(
              context,
              page: LandingPage(selectedIndex: 0),
            );

            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state),
            //     backgroundColor: Colors.green,
            //   ),
            // );
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
                  // bottom: 50,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                TextStyles.textHeadings(
                                  textValue: "Sign In",
                                  textColor: AppColors.black,

                                  textSize: 30,
                                ),
                                const SizedBox(height: 20),
                                const CustomText(
                                  text:
                                  'Welcome back! Your next cup is just a tap away.',
                                  size: 16,
                                  maxLines: 2,
                                  color: AppColors.textColor,

                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      CustomTextFormField(
                                        hint: 'Email',
                                        label: '',
                                        controller: _emailController,
                                        borderColor:
                                        AppColors
                                            .textFormFieldBackgroundColor,
                                        backgroundColor:
                                        AppColors
                                            .textFormFieldBackgroundColor,
                                        validator:
                                        AppValidator.validateTextfield,
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextFormField(
                                        label: '',
                                        isPasswordField: true,
                                        backgroundColor:
                                        AppColors
                                            .textFormFieldBackgroundColor,
                                        validator:
                                        AppValidator.validateTextfield,
                                        controller: _passwordController,
                                        hint: 'Password',
                                        borderColor:
                                        AppColors
                                            .textFormFieldBackgroundColor,
                                      ),
                                      const SizedBox(height: 5),
                                      GestureDetector(
                                        onTap: () {
                                          AppNavigator.pushAndStackPage(
                                            context,
                                            page: const ResetPasswordRequest(),
                                          );
                                        },
                                        child: const Align(
                                          alignment: Alignment.bottomRight,
                                          child: CustomText(
                                            text: "Forgot password ?",
                                            color: Color(0xff1769FF),
                                            size: 14,
                                            weight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      FormButton(
                                        onPressed: _handleSignIn,
                                        text: 'Login',
                                        borderColor: AppColors.appMainColor,
                                        bgColor: AppColors.appMainColor,
                                        textColor: AppColors.white,
                                        borderRadius: 12,
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
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
                                const SizedBox(height: 10),
                                SocialLoginButton(
                                  buttonType: SocialLoginButtonType.google,
                                  onPressed: () {},
                                  imageWidth: 30,

                                  borderRadius: 12,
                                  backgroundColor:
                                  AppColors.textFormFieldBackgroundColor,
                                ),

                                const SizedBox(height: 20),
                                SocialLoginButton(
                                  buttonType: SocialLoginButtonType.apple,
                                  onPressed: () {},
                                  borderRadius: 12,
                                  imageWidth: 30,
                                  backgroundColor:
                                  AppColors.textFormFieldBackgroundColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: TextStyles.richTexts(
                            text1: 'Don\'t have an account yet? ',
                            text2: "create one",
                            size: 14,
                            onPress2: () {},
                            weight: FontWeight.w400,
                            color2: AppColors.blue,
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
