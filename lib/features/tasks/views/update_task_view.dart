// ignore_for_file: strict_top_level_inference
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/shared_widgets/custom_btn.dart';
import 'package:to_do/core/shared_widgets/custom_icon_btn.dart';
import 'package:to_do/core/shared_widgets/custom_text_field.dart';
import 'package:to_do/core/shared_widgets/image_manager.dart';
import 'package:to_do/core/utils/app_images.dart';
import 'package:to_do/features/home/data/models/task_model.dart';
import '../../../core/network/api_helper.dart';
import '../../../core/utils/app_colors.dart';

class UpdateTaskView extends StatefulWidget {
  const UpdateTaskView({super.key, required this.taskModel});
  final TaskModel taskModel;
  @override
  State<UpdateTaskView> createState() => _UpdateTaskViewState();
}

class _UpdateTaskViewState extends State<UpdateTaskView> {
  final title = TextEditingController();
  final desc = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? imagePath;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    title.text = widget.taskModel.title ?? '';
    desc.text = widget.taskModel.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: Text('Update Task'),
        actions: [
          Padding(
            padding: REdgeInsets.only(right: 10),
            child: CustomIconBtn(
              onIconPressed: () async {
                var result = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Yes'),
                      ),
                    ],
                  ),
                );

                if (result == true) {
                  onDeleteTaskPressed();
                }
              },
              icon: Icons.delete,
              iconName: 'Delete Task',
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: REdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 45.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: ImageManager(
                    unselectedImageBuilder: Image.asset(
                      AppImages.flag,
                      height: 207.h,
                      width: 260.w,
                      fit: BoxFit.cover,
                    ),
                    networkImageBuilder: widget.taskModel.imagePath == null
                        ? null
                        : Image.network(
                            widget.taskModel.imagePath!,
                            height: 207.h,
                            width: 260.w,
                            fit: BoxFit.cover,
                          ),
                    selectedImageBuilder: (String path) {
                      imagePath = path;
                      return Image.file(
                        File(path),
                        height: 207.h,
                        width: 260.w,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),

                Text('Update Task Image'),
                SizedBox(height: 30.h),
                CustomTextField(
                  controller: title,
                  lableText: 'Updat Title',
                  validator: (String? value) {
                    if (value == null || value.isEmpty == true) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: desc,
                  lableText: 'Update Description',
                ),
                SizedBox(height: 15.h),
                isLoading
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : CustomBTN(
                        text: 'Update Task',
                        onPressed: onUpdateTaskPressed,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onUpdateTaskPressed() async {
    if (formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      var result = await APIHelper.updateTask(
        id: widget.taskModel.id ?? 0,
        title: title.text,
        description: desc.text,
        imagePath: imagePath,
      );
      result.fold(
        (errorMsg) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg, style: TextStyle(color: AppColors.white)),
            backgroundColor: AppColors.error,
          ),
        ),
        (successMsg) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                successMsg,
                style: TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context, true);
        },
      );
    }
  }

  onDeleteTaskPressed() async {
    if (formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      var result = await APIHelper.deleteTask(id: widget.taskModel.id ?? 0);
      result.fold(
        (errorMsg) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg, style: TextStyle(color: AppColors.white)),
            backgroundColor: AppColors.error,
          ),
        ),
        (successMsg) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                successMsg,
                style: TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context, true);
        },
      );
    }
  }
}
