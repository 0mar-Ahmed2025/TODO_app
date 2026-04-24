import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomGoToBtn extends StatelessWidget {
  const CustomGoToBtn({
    super.key,
    required this.onPressed,
    required this.text,
    this.leading,
    this.trailing,
  });

  final void Function()? onPressed;
  final String text;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 63.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ListTile(
        onTap: onPressed,
        title: Text(text),
        leading: leading,
        trailing: trailing,
      ),
    );
  }
}
