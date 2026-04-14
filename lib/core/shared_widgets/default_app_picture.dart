import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/utils/app_images.dart';

class DefaultAppPicture extends StatelessWidget {
  const DefaultAppPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 298.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        image: DecorationImage(
          image: AssetImage(AppImages.flag),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
