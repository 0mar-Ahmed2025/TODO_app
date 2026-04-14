// ignore_for_file: strict_top_level_inference

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/core/network/api_helper.dart';
import 'package:to_do/core/shared_widgets/custom_btn.dart';
import 'package:to_do/core/shared_widgets/custom_text_field.dart';
import 'package:to_do/core/shared_widgets/image_manager.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_images.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final title = TextEditingController();
  final desc = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? imagePath;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: Text('Add Task'),
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
                Text('Pick Task Image'),
                SizedBox(height: 30.h),
                CustomTextField(
                  controller: title,
                  hintText: 'Enter Task Title',
                  lableText: 'Title',
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
                  hintText: 'Enter Task Description',
                  lableText: 'Description',
                ),
                SizedBox(height: 15.h),
                isLoading
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : CustomBTN(text: 'Add Task', onPressed: onAddTaskPressed),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onAddTaskPressed() async {
    if (formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true;
      });
      var result = await APIHelper.addTask(
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
}
