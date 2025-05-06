import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/view/auth/reset_password.dart';
import 'package:refreshing_co/view/auth/reset_password_screen.dart';
import 'package:refreshing_co/view/auth/sign_in_screen.dart';
import 'package:refreshing_co/view/auth/sign_up_screen.dart';
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

class ResetPasswordRequest extends StatefulWidget {
  const ResetPasswordRequest({super.key});

  @override
  State<ResetPasswordRequest> createState() => _ResetPasswordRequestState();
}

class _ResetPasswordRequestState extends State<ResetPasswordRequest> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
                        text: 'Forgot your password? Don’t worry, enter your '
                            'email to reset your current password.',
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
                              FormButton(
                                onPressed: () async {
                                  AppNavigator.pushAndStackPage(context,
                                      page: const ResetPassword());
                                },
                                text: 'Submit',
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
                    ],
                  ),
                ),
              ),
              TextStyles.richTexts(
                  text1: 'Have an account with us? ',
                  text2: "Login",
                  size: 16,
                  onPress2: () {
                    AppNavigator.pushAndRemovePreviousPages(context,
                        page: const SignInScreen());
                  },
                  weight: FontWeight.w400,
                  color2: AppColors.blue)
            ],
          ),
        ),
      ),
    );
  }
}
