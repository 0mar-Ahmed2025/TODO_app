import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.lableText,
  });

  final TextEditingController controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? lableText;

  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      style: TextStyle(
        fontSize: 14.sp,
        color: AppColors.black,
        fontWeight: AppFontWeight.extraLight,
      ),
      decoration: InputDecoration(
        labelText: lableText,
        labelStyle: TextStyle(
          fontWeight: AppFontWeight.regulare,
          fontSize: 14.sp,
          color: AppColors.hint,
        ),
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: AppFontWeight.light,
          fontSize: 14.sp,
          color: AppColors.hint,
        ),
        border: borderBuilder(),
        enabledBorder: borderBuilder(),
        focusedBorder: borderBuilder(color: AppColors.primary),
        focusedErrorBorder: borderBuilder(color: AppColors.primary),
        errorBorder: borderBuilder(color: AppColors.error),
      ),
    );
  }

  InputBorder borderBuilder({Color color = AppColors.lightGrey}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: color),
    );
  }
}
