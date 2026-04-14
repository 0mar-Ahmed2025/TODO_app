import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:to_do/core/cache/cache_helper.dart';
import 'package:to_do/core/cache/cache_keys.dart';
import 'package:to_do/core/network/api_helper.dart';
import 'package:to_do/core/translation/translations_helper.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/features/get_start/views/splash_view.dart';
import 'package:to_do/features/home/views/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await APIHelper.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: TranslationHelper(),
        locale: Locale('en'),
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.scaffoldBackground,
          ),
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          fontFamily: 'Lexend_Deca',
        ),
        home: CacheHelper.getValue(CacheKeys.accessToken) != null
            ? MainLayout()
            : SplashView(),
      ),
    );
  }
}
