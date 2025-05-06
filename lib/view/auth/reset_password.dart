import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextStyles.textHeadings(
                    textValue: "Reset Password",
                    textColor: AppColors.black,
                    textSize: 30),
                const SizedBox(
                  height: 20,
                ),
                const CustomText(
                  text: 'Create a new, strong password that only you can remember.',
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
                          label: '',
                          isPasswordField: true,
                          backgroundColor:
                          AppColors.textFormFieldBackgroundColor,
                          validator: AppValidator.validateTextfield,
                          controller: _passwordController,
                          hint: 'New Password',
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
                          text: 'Verify',
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
      ),
    );
  }
}
