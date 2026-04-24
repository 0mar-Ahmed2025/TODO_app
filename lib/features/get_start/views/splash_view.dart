// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/helper/app_navigator.dart';
import 'package:to_do/core/shared_widgets/custom_svg_wrapper.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';
import 'package:to_do/core/utils/app_images.dart';
import 'package:to_do/features/get_start/views/get_start_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () => MyNavigator.goto(
        context,
        GetStartView(),
        type: NavigatorType.pushAndRemoveUntil,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSvgWrapper(
            path: AppImages.logo,
            width: double.infinity,
            height: 344.h,
          ),
          SizedBox(height: 45.h),
          Center(
            child: Text(
              'TODO',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: AppFontWeight.bold,
                fontSize: 36.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
