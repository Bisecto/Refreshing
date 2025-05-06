import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/view/auth/reset_password_screen.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../../utills/app_validator.dart';
import '../widgets/app_custom_text.dart';
import '../widgets/form_button.dart';
import '../widgets/form_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    // TODO: implement initState
    //authBloc.add(InitialEvent());
    //AppUtils().logout(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        // bottom: 50,
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
                    const SizedBox(
                      height: 20,
                    ),
                    TextStyles.textSubHeadings(
                        textValue: "Sign In",
                        textColor: AppColors.black,
                        textSize: 25),
                    const SizedBox(
                      height: 20,
                    ),
                    const CustomText(
                      text:
                          'Looks like you don’t have an account. Let’s create a new account for you.',
                      size: 16,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              hint: 'Username',
                              label: '',
                              controller: _usernameController,
                              borderColor:
                                  AppColors.textFormFieldBackgroundColor,
                              backgroundColor:
                                  AppColors.textFormFieldBackgroundColor,
                              validator: AppValidator.validateTextfield,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              hint: 'Email',
                              label: '',
                              controller: _emailController,
                              borderColor:
                                  AppColors.textFormFieldBackgroundColor,
                              backgroundColor:
                                  AppColors.textFormFieldBackgroundColor,
                              validator: AppValidator.validateTextfield,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: '',
                              isPasswordField: true,
                              backgroundColor:
                                  AppColors.textFormFieldBackgroundColor,
                              validator: AppValidator.validateTextfield,
                              controller: _passwordController,
                              hint: 'Password',
                              borderColor:
                                  AppColors.textFormFieldBackgroundColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: '',
                              isPasswordField: true,
                              backgroundColor:
                              AppColors.textFormFieldBackgroundColor,
                              validator: AppValidator.validateTextfield,
                              controller: _confirmPasswordController,
                              hint: 'Confirm Password',
                              borderColor:
                              AppColors.textFormFieldBackgroundColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            FormButton(
                              onPressed: () async {},
                              text: 'Create Account',
                              borderColor: AppColors.appMainColor,
                              bgColor: AppColors.appMainColor,
                              textColor: AppColors.white,
                              borderRadius: 12,
                              height: 50,
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(children: <Widget>[
                      Expanded(
                          child: Divider(
                        color: AppColors.textFormFieldBackgroundColor,
                      )),
                      Text("  OR  "),
                      Expanded(
                          child: Divider(
                        color: AppColors.textFormFieldBackgroundColor,
                      )),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    SocialLoginButton(
                      buttonType: SocialLoginButtonType.apple,
                      onPressed: () {},
                      borderRadius: 12,
                      backgroundColor: AppColors.textFormFieldBackgroundColor,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SocialLoginButton(
                      buttonType: SocialLoginButtonType.google,
                      onPressed: () {},
                      borderRadius: 12,
                      backgroundColor: AppColors.textFormFieldBackgroundColor,
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){

              },
              child:  TextStyles.richTexts(
                  text1: 'Have an account with us? ',
                  text2: "create one",
                  size: 16,
                  weight: FontWeight.w400,
                  color2: AppColors.blue)
            )
            ,

          ],
        ),
      ),
    );
  }
}
