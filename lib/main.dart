import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:to_do/core/cache/cache_helper.dart';
import 'package:to_do/core/network/api_helper.dart';
import 'package:to_do/core/translation/translations_helper.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/features/get_start/views/splash_view.dart';
import 'package:to_do/features/home/cubits/get_tasks_cubit/get_tasks_cubit.dart';
import 'package:to_do/features/home/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await APIHelper.init();
  String? token = CacheHelper.getValue('access_token');

  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isLoggedIn = false});
  final bool isLoggedIn;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          isLoggedIn ? (GetTasksCubit()..getTasks()) : GetTasksCubit(),
      child: ScreenUtilInit(
        designSize: Size(375, 812),
        builder: (context, widget) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: TranslationHelper(),
            locale: Locale('en'),
            theme: ThemeData(
              fontFamily: 'Cairo',
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            ),
            home: isLoggedIn ? HomeView() : SplashView(),
          );
        },
      ),
    );
  }
}
