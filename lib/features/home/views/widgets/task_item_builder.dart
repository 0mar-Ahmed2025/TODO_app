import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/features/home/data/models/task_model.dart';

class TaskItemBuilder extends StatelessWidget {
  const TaskItemBuilder({
    super.key,
    required this.task,
    required this.taskImage,
    this.onTap,
  });

  final TaskModel task;
  final String taskImage;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: REdgeInsets.only(top: 20),
        padding: REdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              offset: Offset.zero,
              blurRadius: 4.r,
              spreadRadius: 0,
              color: AppColors.black.withAlpha(60),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: REdgeInsets.only(left: 1),
          title: Text(task.title!),
          subtitle: Text(task.description!),
          leading: SizedBox(
            width: 30.w,
            child: CircleAvatar(
              backgroundImage: task.imagePath == null
                  ? AssetImage(taskImage)
                  : NetworkImage(task.imagePath!),
            ),
          ),
          trailing: SizedBox(
            width: 80,
            child: Text(
              task.createdAt!,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ),
      ),
    );
  }
}
