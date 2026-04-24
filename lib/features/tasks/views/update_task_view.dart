import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do/core/helper/app_pop_up.dart';
import 'package:to_do/core/helper/app_validator.dart';
import 'package:to_do/core/shared_widgets/custom_filled_btn.dart';
import 'package:to_do/core/shared_widgets/custom_icon_btn.dart';
import 'package:to_do/core/shared_widgets/custom_text_field.dart';
import 'package:to_do/core/shared_widgets/image_manager.dart';
import 'package:to_do/core/translation/translation_keys.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_images.dart';
import 'package:to_do/features/home/cubits/get_tasks_cubit/get_tasks_cubit.dart';
import 'package:to_do/features/home/data/models/task_model.dart';
import 'package:to_do/features/tasks/cubits/delete_task_cubit/delete_task_cubit.dart';
import 'package:to_do/features/tasks/cubits/delete_task_cubit/delete_task_state.dart';
import 'package:to_do/features/tasks/cubits/update_task_cubit/update_task_cubit.dart';
import 'package:to_do/features/tasks/cubits/update_task_cubit/update_task_state.dart';

class UpdateTaskView extends StatelessWidget {
  const UpdateTaskView({super.key, required this.taskModel});
  final TaskModel taskModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateTaskCubit(taskModel),
      child: Scaffold(
        appBar: AppBar(
          title: Text(TranslationKeys.updateTask.tr),
          actions: [
            BlocProvider(
              create: (context) => DeleteTaskCubit(),
              child: BlocConsumer<DeleteTaskCubit, DeleteTaskState>(
                listener: (context, state) {
                  if (state is DeleteTaskErrorState) {
                    SnackBarPopUp().show(
                      context: context,
                      message: state.error,
                      state: PopUpState.error,
                    );
                  } else if (state is DeleteTaskSuccessState) {
                    SnackBarPopUp().show(
                      context: context,
                      message: 'Taske Deleted successfully',
                      state: PopUpState.success,
                    );

                    GetTasksCubit.get(context).getTasks();
                    Navigator.pop(context);
                    //  Navigator.pop(context, true);
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      CustomIconBtn(
                        onIconPressed: state is! DeleteTaskLoadingState
                            ? () => DeleteTaskCubit.get(
                                context,
                              ).onDeleteTaskPressed(taskModel.id!)
                            : null,
                        iconName: TranslationKeys.deleteTask.tr,
                        icon: Icons.delete,
                        color: Colors.red,
                      ),
                      if (state is DeleteTaskLoadingState)
                        SizedBox(
                          width: 50,
                          child: LinearProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<UpdateTaskCubit, UpdateTaskState>(
            listener: (context, state) {
              if (state is UpdateTaskErrorState) {
                SnackBarPopUp().show(
                  context: context,
                  message: state.error,
                  state: PopUpState.error,
                );
              } else if (state is UpdateTaskSuccessState) {
                SnackBarPopUp().show(
                  context: context,
                  message: 'Taske Updateed successfully',
                  state: PopUpState.success,
                );

                GetTasksCubit.get(context).getTasks();
                Navigator.pop(context);
                //  Navigator.pop(context, true);
              }
            },
            builder: (context, state) {
              return Form(
                key: UpdateTaskCubit.get(context).formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: ImageManager(
                          unselectedImageBuilder: Container(
                            width: 261.w,
                            height: 207.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: taskModel.imagePath == null
                                    ? AssetImage(AppImages.flag)
                                    : NetworkImage(taskModel.imagePath!),
                              ),
                            ),
                          ),
                          selectedImageBuilder: (XFile path) {
                            UpdateTaskCubit.get(context).image = path;
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
                      Text(TranslationKeys.updateTaskImage.tr),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: UpdateTaskCubit.get(context).title,
                        prefixIcon: Icon(Icons.title),
                        hintText: TranslationKeys.title.tr,
                        validator: AppValidator.validateRequired,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: UpdateTaskCubit.get(context).description,
                        prefixIcon: Icon(Icons.description),
                        hintText: TranslationKeys.description.tr,
                        validator: AppValidator.validateRequired,
                      ),
                      SizedBox(height: 20),
                      state is UpdateTaskLoadingState
                          ? CircularProgressIndicator()
                          : CustomFilledBtn(
                              onPressed: UpdateTaskCubit.get(
                                context,
                              ).onUpdateTaskPressed,
                              text: TranslationKeys.updateTask.tr,
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
