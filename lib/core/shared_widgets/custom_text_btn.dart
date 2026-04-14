import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';

class CustomTextBtn extends StatelessWidget {
  const CustomTextBtn({super.key, required this.text, this.onPressed});

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: AppFontWeight.regulare,
          color: AppColors.primary,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
