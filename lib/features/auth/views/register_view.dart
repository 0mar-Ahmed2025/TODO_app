// ignore_for_file: prefer_typing_uninitialized_variables, strict_top_level_inference

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/helper/app_navigator.dart';
import 'package:to_do/core/network/api_helper.dart';
import 'package:to_do/core/shared_widgets/custom_btn.dart';
import 'package:to_do/core/shared_widgets/custom_svg_wrapper.dart';
import 'package:to_do/core/shared_widgets/custom_text_btn.dart';
import 'package:to_do/core/shared_widgets/custom_text_field.dart';
import 'package:to_do/core/shared_widgets/image_manager.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';
import 'package:to_do/core/utils/app_icons.dart';
import 'package:to_do/core/utils/app_images.dart';
import 'package:to_do/core/utils/app_paddings.dart';
import 'package:to_do/features/auth/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _LoginViewState();
}

class _LoginViewState extends State<RegisterView> {
  var username = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? imagePath;

  bool passwordSecure = true;
  bool confirmPasswordSecure = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: ImageManager(
                  unselectedImageBuilder: Image.asset(
                    AppImages.flag,
                    height: 298.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  selectedImageBuilder: (String path) {
                    imagePath = path;
                    return Image.file(
                      File(path),
                      height: 298.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(height: 15.h),
              Text('Pick Profile Image'),
              SizedBox(height: 23.h),
              Padding(
                padding: AppPaddings.defaultPadding,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: username,
                      hintText: 'Username',
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: CustomSvgWrapper(path: AppIcons.profileIcon),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      controller: password,
                      hintText: 'Password',
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
                    SizedBox(height: 10.h),
                    CustomTextField(
                      controller: confirmPassword,
                      hintText: 'Confirm Password',
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: CustomSvgWrapper(path: AppIcons.keyIcon),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            confirmPasswordSecure = !confirmPasswordSecure;
                          });
                        },
                        icon: CustomSvgWrapper(
                          path: confirmPasswordSecure
                              ? AppIcons.lockIcon
                              : AppIcons.unlockIcon,
                        ),
                      ),
                      obscureText: confirmPasswordSecure,
                    ),
                    SizedBox(height: 23.h),
                    CustomBTN(text: 'Register', onPressed: onRegisterPressed),
                    SizedBox(height: 42.h),
                    if (isLoading)
                      CircularProgressIndicator(color: AppColors.primary),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Alrady Have An Account?",
                          style: AppTextStyles.haveAnAccount,
                        ),
                        CustomTextBtn(
                          text: 'Login',
                          onPressed: () => MyNavigator.goto(
                            context,
                            LoginView(),
                            type: NavigatorType.pop,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onRegisterPressed() async {
    if (formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      var result = await APIHelper.register(
        userName: username.text,
        password: password.text,
        imagePath: imagePath,
      );
      result.fold(
        (errorMsg) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg, style: TextStyle(color: AppColors.white)),
            backgroundColor: AppColors.error,
          ),
        ),
        (successMsg) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                successMsg,
                style: TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context);
        },
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}
