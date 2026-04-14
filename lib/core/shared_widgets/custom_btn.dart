import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';

class CustomBTN extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const CustomBTN({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 15,
          shadowColor: AppColors.black.withValues(alpha: 60),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 19.sp,
            fontWeight: AppFontWeight.light,
          ),
        ),
      ),
    );
  }
}
