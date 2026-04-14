import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/helper/app_navigator.dart';
import 'package:to_do/core/network/api_helper.dart';
import 'package:to_do/core/shared_widgets/custom_btn.dart';
import 'package:to_do/core/shared_widgets/custom_svg_wrapper.dart';
import 'package:to_do/core/shared_widgets/custom_text_btn.dart';
import 'package:to_do/core/shared_widgets/custom_text_field.dart';
import 'package:to_do/core/shared_widgets/default_app_picture.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';
import 'package:to_do/core/utils/app_icons.dart';
import 'package:to_do/core/utils/app_paddings.dart';
import 'package:to_do/features/auth/data/model/user_model.dart';
import 'package:to_do/features/auth/views/register_view.dart';
import 'package:to_do/features/home/views/main_layout.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  bool passwordSecure = true;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DefaultAppPicture(),
            SizedBox(height: 23.h),
            Padding(
              padding: AppPaddings.defaultPadding,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: username,
                      hintText: 'Username',
                      validator: (String? value) {
                        if (value == null || value.isEmpty == true) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: CustomSvgWrapper(path: AppIcons.profileIcon),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      controller: password,
                      hintText: 'Password',
                      // validator: (String? value) {
                      //   // regex
                      //   RegExp passwordRegex = RegExp(r'^[\w]{6,}$');
                      //   bool result = passwordRegex.hasMatch(value ?? '');
                      //   return result
                      //       ? null
                      //       : 'Password must contain A-Z, a-z, 0-9 and\nat least 6 characters';
                      // },
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: CustomSvgWrapper(path: AppIcons.keyIcon),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordSecure = !passwordSecure;
                          });
                        },
                        icon: CustomSvgWrapper(
                          path: passwordSecure
                              ? AppIcons.lockIcon
                              : AppIcons.unlockIcon,
                        ),
                      ),
                      obscureText: passwordSecure,
                    ),
                    SizedBox(height: 23.h),
                    isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : CustomBTN(text: 'Login', onPressed: login),
                    SizedBox(height: 42.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have An Account?",
                          style: AppTextStyles.haveAnAccount,
                        ),
                        CustomTextBtn(
                          text: 'Register',
                          onPressed: () =>
                              MyNavigator.goto(context, RegisterView()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      var result = await APIHelper.login(
        username: username.text,
        password: password.text,
      );
      result.fold(
        (String error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error, style: TextStyle(color: AppColors.white)),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (UserModel userModel) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Login successfully\n Welcome ${userModel.username}',
                style: TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainLayout()),
            (r) => false,
          );
        },
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}
