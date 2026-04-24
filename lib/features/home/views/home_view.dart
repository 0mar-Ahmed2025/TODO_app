// ignore_for_file: use_build_context_synchronously, strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/utils.dart';
import 'package:to_do/core/cache/cache_helper.dart';
import 'package:to_do/core/cache/cache_keys.dart';
import 'package:to_do/core/helper/app_navigator.dart';
import 'package:to_do/core/shared_widgets/custom_icon_btn.dart';
import 'package:to_do/core/shared_widgets/custom_svg_wrapper.dart';
import 'package:to_do/core/translation/translation_keys.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';
import 'package:to_do/core/utils/app_icons.dart';
import 'package:to_do/core/utils/app_images.dart';
import 'package:to_do/features/auth/data/models/user_model.dart';
import 'package:to_do/features/auth/views/login_view.dart';
import 'package:to_do/features/home/cubits/get_tasks_cubit/get_tasks_cubit.dart';
import 'package:to_do/features/home/cubits/get_tasks_cubit/get_tasks_states.dart';
import 'package:to_do/features/users/cubits/get_user_data_cubit/get_user_data_cubit.dart';
import 'package:to_do/features/users/cubits/get_user_data_cubit/get_user_data_states.dart';
import 'package:to_do/features/users/views/profile_view.dart';
import 'package:to_do/features/home/views/widgets/task_item_builder.dart';
import 'package:to_do/features/tasks/views/add_task_view.dart';
import 'package:to_do/features/tasks/views/update_task_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) {
          return customFloatingActionBtn(
            onPressed: () async {
              bool added =
                  await MyNavigator.goto(context, AddTaskView()) ?? false;
              if (added) {
                GetTasksCubit.get(context).getTasks();
              }
            },
          );
        },
      ),
      appBar: AppBar(
        elevation: 1,
        title: BlocProvider(
          create: (context) => GetUserDataCubit()..getUserDataPressed(),
          child: BlocBuilder<GetUserDataCubit, GetUserDataState>(
            builder: (context, state) {
              if (state is GetUserDataLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is GetUserDataErrorState) {
                return Center(
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          CacheHelper.removeValue(CacheKeys.accessToken);
                          MyNavigator.goto(
                            context,
                            LoginView(),
                            type: NavigatorType.pushAndRemoveUntil,
                          );
                        },
                        child: Text('Logout'),
                      ),
                      Text(state.error),
                    ],
                  ),
                );
              } else if (state is GetUserDataSuccessState) {
                return ListTile(
                  contentPadding: REdgeInsets.symmetric(horizontal: 0),
                  title: Text(
                    TranslationKeys.hello.tr,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  subtitle: GestureDetector(
                    onTap: () =>
                        onPrfileTaped(user: state.user, context: context),
                    child: Text(
                      state.user.username!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: AppFontWeight.medium,
                      ),
                    ),
                  ),
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 5),
                          spreadRadius: 0,
                          color: AppColors.black.withAlpha(60),
                          blurRadius: 3.r,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () =>
                          onPrfileTaped(context: context, user: state.user),
                      child: CircleAvatar(
                        backgroundImage: state.user.imagePath == null
                            ? AssetImage(AppImages.flag)
                            : NetworkImage(state.user.imagePath!),
                      ),
                    ),
                  ),
                  trailing: CustomIconBtn(
                    onIconPressed: () async {
                      await CacheHelper.removeValue(CacheKeys.accessToken);
                      await CacheHelper.removeValue(CacheKeys.refreshToken);
                      MyNavigator.goto(
                        context,
                        LoginView(),
                        type: NavigatorType.pushAndRemoveUntil,
                      );
                    },
                    icon: Icons.logout,
                    iconName: TranslationKeys.logout.tr,
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              GetTasksCubit.get(context).getTasks();
            },
            child: BlocBuilder<GetTasksCubit, GetTasksStates>(
              builder: (context, state) {
                if (state is GetTasksLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state is GetTasksErrorState) {
                  return Center(child: Text(state.error));
                } else if (state is GetTasksSuccessState) {
                  return ListView.builder(
                    padding: REdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) => TaskItemBuilder(
                      onTap: () {
                        MyNavigator.goto(
                          context,
                          UpdateTaskView(taskModel: state.tasks[index]),
                        );
                      },
                      task: state.tasks[index],
                      taskImage: state.tasks[index].imagePath == null
                          ? AppImages.flag
                          : state.tasks[index].imagePath!,
                    ),
                  );
                } else if (state is EmptyTasksState) {
                  return emptyHomeView();
                }
                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}

onPrfileTaped({required UserModel user, required BuildContext context}) {
  MyNavigator.goto(
    context,
    ProfileView(userModel: user),
    type: NavigatorType.push,
  );
}

Widget emptyHomeView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'There are no tasks yet\nPress the button\nTo add New Task',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp),
        ),
        SizedBox(height: 30.h),
        CustomSvgWrapper(path: AppImages.homeObj),
      ],
    ),
  );
}

Widget customFloatingActionBtn({required void Function()? onPressed}) {
  return FloatingActionButton(
    tooltip: 'add task',
    shape: CircleBorder(),
    backgroundColor: AppColors.primary,
    onPressed: onPressed,
    child: CustomSvgWrapper(path: AppIcons.paperPlusIcon),
  );
}
