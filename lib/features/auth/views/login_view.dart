import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:to_do/core/helper/app_navigator.dart';
import 'package:to_do/core/helper/app_pop_up.dart';
import 'package:to_do/core/helper/app_validator.dart';
import 'package:to_do/core/shared_widgets/custom_btn.dart';
import 'package:to_do/core/shared_widgets/custom_svg_wrapper.dart';
import 'package:to_do/core/shared_widgets/custom_text_btn.dart';
import 'package:to_do/core/shared_widgets/custom_text_field.dart';
import 'package:to_do/core/shared_widgets/default_app_picture.dart';
import 'package:to_do/core/translation/translation_keys.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';
import 'package:to_do/core/utils/app_icons.dart';
import 'package:to_do/core/utils/app_paddings.dart';
import 'package:to_do/features/auth/cubits/login/login_cubit.dart';
import 'package:to_do/features/auth/cubits/login/login_states.dart';
import 'package:to_do/features/auth/views/register_view.dart';
import 'package:to_do/features/home/cubits/get_tasks_cubit/get_tasks_cubit.dart';
import 'package:to_do/features/home/views/home_view.dart';
import 'package:to_do/features/home/views/main_layout.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LoginErrorState) {
              SnackBarPopUp().show(
                context: context,
                message: state.error,
                state: PopUpState.error,
              );
            } else if (state is LoginSuccessState) {
              SnackBarPopUp().show(
                context: context,
                message:
                    'Login successfully\n Welcome ${state.userModel.username}',
                state: PopUpState.success,
              );
              GetTasksCubit.get(context).getTasks();
              MyNavigator.goto(
                context,
                HomeView(),
                type: NavigatorType.pushAndRemoveUntil,
              );
            }
          },
          builder: (context, state) {
            var cubit = LoginCubit.get(context);
            return SingleChildScrollView(
              child: Column(
                children: [
                  DefaultAppPicture(),
                  SizedBox(height: 23.h),
                  Padding(
                    padding: AppPaddings.defaultPadding,
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: cubit.username,
                            hintText: TranslationKeys.userName.tr,
                            validator: AppValidator.validateRequired,
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
                            validator: AppValidator.validateRequired,
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
                          SizedBox(height: 23.h),
                          state is LoginLoadingState
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                )
                              : CustomBTN(
                                  text: TranslationKeys.login.tr,
                                  onPressed: cubit.login,
                                ),
                          SizedBox(height: 42.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TranslationKeys.dontHaveAccount.tr,
                                style: AppTextStyles.haveAnAccount,
                              ),
                              CustomTextBtn(
                                text: TranslationKeys.register.tr,
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
            );
          },
        ),
      ),
    );
  }
}
