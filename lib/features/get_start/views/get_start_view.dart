import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/helper/app_navigator.dart';
import 'package:to_do/core/shared_widgets/custom_btn.dart';
import 'package:to_do/core/shared_widgets/custom_svg_wrapper.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';
import 'package:to_do/core/utils/app_images.dart';
import 'package:to_do/core/utils/app_paddings.dart';
import 'package:to_do/features/auth/views/login_view.dart';

class GetStartView extends StatelessWidget {
  const GetStartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppPaddings.defaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomSvgWrapper(
              path: AppImages.vector,
              height: 343.h,
              width: 301.w,
            ),
            Text(
              'Welcome To\nDo It !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                color: AppColors.black,
                fontWeight: AppFontWeight.regulare,
              ),
            ),
            Text(
              "Ready to conquer your tasks? Let's\nDo It together",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
                fontWeight: AppFontWeight.regulare,
              ),
            ),

            CustomBTN(
              text: "Let's Start",
              onPressed: () => MyNavigator.goto(
                context,
                LoginView(),
                type: NavigatorType.push,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
