import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/utils/app_images.dart';

class DefaultAppPicture extends StatelessWidget {
  const DefaultAppPicture({
    super.key,
    this.height = 298,
    this.width = double.infinity,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
