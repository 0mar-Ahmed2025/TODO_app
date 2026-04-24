import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do/core/helper/app_pop_up.dart';
import 'package:to_do/core/helper/app_validator.dart';
import 'package:to_do/core/shared_widgets/custom_filled_btn.dart';
import 'package:to_do/core/shared_widgets/custom_text_field.dart';
import 'package:to_do/core/shared_widgets/default_app_picture.dart';
import 'package:to_do/core/shared_widgets/image_manager.dart';
import 'package:to_do/core/translation/translation_keys.dart';
import 'package:to_do/features/home/cubits/get_tasks_cubit/get_tasks_cubit.dart';
import 'package:to_do/features/tasks/cubits/add_task_cubit/add_task_cubit.dart';
import 'package:to_do/features/tasks/cubits/add_task_cubit/add_task_state.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(TranslationKeys.addTask.tr)),
        body: BlocConsumer<AddTaskCubit, AddTaskState>(
          listener: (context, state) {
            if (state is AddTaskErrorState) {
              SnackBarPopUp().show(
                context: context,
                message: state.error,
                state: PopUpState.error,
              );
            } else if (state is AddTaskSuccessState) {
              SnackBarPopUp().show(
                context: context,
                message: 'Taske added successfully',
                state: PopUpState.success,
              );

              GetTasksCubit.get(context).getTasks();
              Navigator.pop(context);
              // Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            return Form(
              key: AddTaskCubit.get(context).formKey,
              child: Padding(
                padding: REdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 45.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: ImageManager(
                          unselectedImageBuilder: DefaultAppPicture(
                            width: 261.w,
                            height: 207.h,
                          ),
                          selectedImageBuilder: (XFile path) {
                            AddTaskCubit.get(context).image = path;
                            return Image.file(
                              File(path.path),
                              width: 261.w,
                              height: 207.h,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(TranslationKeys.pickTaskImage.tr),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: AddTaskCubit.get(context).title,
                        prefixIcon: Icon(Icons.title),
                        hintText: TranslationKeys.title.tr,
                        validator: AppValidator.validateRequired,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: AddTaskCubit.get(context).description,
                        prefixIcon: Icon(Icons.description),
                        hintText: TranslationKeys.description.tr,
                        validator: AppValidator.validateRequired,
                      ),
                      SizedBox(height: 20.h),
                      state is AddTaskLoadingState
                          ? Center(child: CircularProgressIndicator())
                          : CustomFilledBtn(
                              onPressed: AddTaskCubit.get(
                                context,
                              ).onAddTaskPressed,
                              text: TranslationKeys.addTask.tr,
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
