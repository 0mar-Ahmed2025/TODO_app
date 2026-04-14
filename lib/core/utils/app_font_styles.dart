import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/utils/app_colors.dart';

abstract class AppFontWeight {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight light = FontWeight.w200;
  static const FontWeight extraLight = FontWeight.w300;
  static const FontWeight regulare = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}

abstract class AppTextStyles {
  static var haveAnAccount = TextStyle(
    fontSize: 14.sp,
    color: AppColors.black,
    fontWeight: AppFontWeight.thin,
  );
}
