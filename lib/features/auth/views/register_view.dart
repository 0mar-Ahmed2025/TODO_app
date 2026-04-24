// ignore_for_file: prefer_typing_uninitialized_variables, strict_top_level_inference
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do/core/helper/app_navigator.dart';
import 'package:to_do/core/helper/app_pop_up.dart';
import 'package:to_do/core/shared_widgets/custom_btn.dart';
import 'package:to_do/core/shared_widgets/custom_svg_wrapper.dart';
import 'package:to_do/core/shared_widgets/custom_text_btn.dart';
import 'package:to_do/core/shared_widgets/custom_text_field.dart';
import 'package:to_do/core/shared_widgets/default_app_picture.dart';
import 'package:to_do/core/shared_widgets/image_manager.dart';
import 'package:to_do/core/translation/translation_keys.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';
import 'package:to_do/core/utils/app_icons.dart';
import 'package:to_do/core/utils/app_paddings.dart';
import 'package:to_do/features/auth/cubits/register/register_cubit.dart';
import 'package:to_do/features/auth/cubits/register/register_states.dart';
import 'package:to_do/features/auth/views/login_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Scaffold(
        body: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            if (state is RegisterErrorState) {
              SnackBarPopUp().show(
                context: context,
                message: state.error,
                state: PopUpState.error,
              );
            } else if (state is RegisterSuccessState) {
              SnackBarPopUp().show(
                context: context,
                message: 'Registered successfully',
                state: PopUpState.success,
              );
              MyNavigator.goto(
                context,
                LoginView(),
                type: NavigatorType.pushAndRemoveUntil,
              );
            }
          },
          builder: (context, state) {
            var cubit = RegisterCubit.get(context);
            return SingleChildScrollView(
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: ImageManager(
                        unselectedImageBuilder: DefaultAppPicture(),
                        selectedImageBuilder: (XFile path) {
                          cubit.imagePath = path.path;
                          return Image.file(
                            File(path.path),
                            height: 298.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(TranslationKeys.pickProfileImage.tr),
                    SizedBox(height: 23.h),
                    Padding(
                      padding: AppPaddings.defaultPadding,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: cubit.username,
                            hintText: TranslationKeys.userName.tr,
                            prefixIcon: IconButton(
                              onPressed: null,
                              icon: CustomSvgWrapper(
                                path: AppIcons.profileIcon,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          CustomTextField(
                            controller: cubit.password,
                            hintText: TranslationKeys.password.tr,
                            prefixIcon: IconButton(
                              onPressed: null,
                              icon: CustomSvgWrapper(path: AppIcons.keyIcon),
                            ),
                            suffixIcon: IconButton(
                              onPressed: cubit.changePasswordVisibility,
                              icon: CustomSvgWrapper(
                                path: cubit.passwordSecure
                                    ? AppIcons.lockIcon
                                    : AppIcons.unlockIcon,
                              ),
                            ),
                            obscureText: cubit.passwordSecure,
                          ),
                          SizedBox(height: 10.h),
                          CustomTextField(
                            controller: cubit.confirmPassword,
                            hintText: TranslationKeys.confirmPassword.tr,
                            prefixIcon: IconButton(
                              onPressed: null,
                              icon: CustomSvgWrapper(path: AppIcons.keyIcon),
                            ),
                            suffixIcon: IconButton(
                              onPressed: cubit.changeConfirmPasswordVisibility,
                              icon: CustomSvgWrapper(
                                path: cubit.confirmPasswordSecure
                                    ? AppIcons.lockIcon
                                    : AppIcons.unlockIcon,
                              ),
                            ),
                            obscureText: cubit.confirmPasswordSecure,
                          ),
                          SizedBox(height: 23.h),
                          state is RegisterLoadingState
                              ? CircularProgressIndicator(
                                  color: AppColors.primary,
                                )
                              : CustomBTN(
                                  text: TranslationKeys.register.tr,
                                  onPressed: cubit.register,
                                ),
                          SizedBox(height: 42.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TranslationKeys.alradyHaveAccount.tr,
                                style: AppTextStyles.haveAnAccount,
                              ),
                              CustomTextBtn(
                                text: TranslationKeys.login.tr,
                                onPressed: () => MyNavigator.goto(
                                  context,
                                  LoginView(),
                                  type: NavigatorType.pushReplacement,
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
            );
          },
        ),
      ),
    );
  }
}
