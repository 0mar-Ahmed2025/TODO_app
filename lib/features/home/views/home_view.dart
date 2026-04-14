// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/utils.dart';
import 'package:to_do/core/cache/cache_helper.dart';
import 'package:to_do/core/cache/cache_keys.dart';
import 'package:to_do/core/helper/app_navigator.dart';
import 'package:to_do/core/network/api_helper.dart';
import 'package:to_do/core/shared_widgets/custom_icon_btn.dart';
import 'package:to_do/core/shared_widgets/custom_svg_wrapper.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/core/utils/app_font_styles.dart';
import 'package:to_do/core/utils/app_icons.dart';
import 'package:to_do/core/utils/app_images.dart';
import 'package:to_do/features/auth/data/model/user_model.dart';
import 'package:to_do/features/auth/views/login_view.dart';
import 'package:to_do/features/home/data/models/task_model.dart';
import 'package:to_do/features/home/views/widgets/task_item_builder.dart';
import 'package:to_do/features/tasks/views/add_task_view.dart';

import '../../../core/translation/translation_keys.dart' show TranslationKeys;

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = false;
  List<TaskModel> tasks = [];
  late UserModel userModel;
  int selectedIndex = 0;
  @override
  void initState() {
    getUserData().then((v) => getTasks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading
          ? null
          : AppBar(
              elevation: 1,
              title: ListTile(
                contentPadding: REdgeInsets.symmetric(horizontal: 1),
                title: Text(
                  TranslationKeys.hello.tr,
                  style: TextStyle(fontSize: 12.sp),
                ),
                subtitle: Text(
                  userModel.username!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: AppFontWeight.medium,
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
                  child: CircleAvatar(
                    backgroundImage: userModel.imagePath == null
                        ? AssetImage(AppImages.flag)
                        : NetworkImage(userModel.imagePath!),
                  ),
                ),
                trailing: CustomIconBtn(
                  onIconPressed: () async {
                    var result = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.primaryLight,
                        title: Text(TranslationKeys.logout.tr),
                        content: Text('Are you sure you want to logout?'),
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
                      onLogoutPreesed();
                    }
                  },
                  icon: Icons.logout,
                  iconName: TranslationKeys.logout.tr,
                ),
              ),
            ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : tasks.isEmpty
          ? emptyHomeView()
          : ListView.builder(
              padding: REdgeInsets.symmetric(horizontal: 20),
              itemCount: tasks.length,
              itemBuilder: (context, index) => TaskItemBuilder(
                task: tasks[index],
                taskImage: tasks[index].imagePath == null
                    ? AppImages.flag
                    : tasks[index].imagePath!,
                onTaskUpdated: () async {
                  setState(() => isLoading = true);
                  await getTasks();
                },
              ),
            ),
      floatingActionButton: customFloatingActionBtn(),
      // bottomNavigationBar: Customs(),
    );
  }

  void onLogoutPreesed() async {
    await CacheHelper.removeValue(CacheKeys.accessToken);
    await CacheHelper.removeValue(CacheKeys.refreshToken);
    MyNavigator.goto(
      context,
      LoginView(),
      type: NavigatorType.pushAndRemoveUntil,
    );
  }

  Widget emptyHomeView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'There are no tasks yet\nPress the button\nTo add New Task ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(height: 30.h),
          CustomSvgWrapper(path: AppImages.homeObj),
        ],
      ),
    );
  }

  Widget customFloatingActionBtn() {
    return FloatingActionButton(
      tooltip: 'add task',
      shape: CircleBorder(),
      backgroundColor: AppColors.primary,
      onPressed: () async {
        var result = await MyNavigator.goto(
          context,
          AddTaskView(),
          type: NavigatorType.push,
        );

        if (result == true) {
          setState(() {
            isLoading = true;
          });

          await getTasks();
        }
      },
      child: CustomSvgWrapper(path: AppIcons.paperPlusIcon),
    );
  }

  Future getTasks() async {
    var result = await APIHelper.getTasks();
    result.fold(
      (error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error, style: TextStyle(color: AppColors.white)),
          backgroundColor: AppColors.error,
        ),
      ),
      (t) => setState(() {
        tasks = t;
      }),
    );

    setState(() {
      isLoading = false;
    });
  }

  Future getUserData() async {
    isLoading = true;
    var result = await APIHelper.getUserData();
    result.fold(
      (error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error, style: TextStyle(color: AppColors.white)),
          backgroundColor: AppColors.error,
        ),
      ),
      (userModel) => setState(() {
        this.userModel = userModel;
      }),
    );
  }
}
