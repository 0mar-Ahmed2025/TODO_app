import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIconBtn extends StatelessWidget {
  const CustomIconBtn({
    super.key,
    this.onIconPressed,
    required this.iconName,
    required this.icon,
    this.color,
  });

  final void Function()? onIconPressed;
  final String iconName;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onIconPressed,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 25.sp, color: color),
          Text(
            iconName,
            style: TextStyle(fontSize: 10.sp, color: color),
          ),
        ],
      ),
    );
  }
}
