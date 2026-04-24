import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:to_do/features/auth/views/login_view.dart';
import 'package:to_do/features/auth/views/register_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20.h),

            TextButton(
              onPressed: () {
                Get.updateLocale(Locale('ar'));
              },
              child: Text('To AR'),
            ),
            TextButton(
              onPressed: () {
                Get.updateLocale(Locale('en'));
              },
              child: Text('To EN'),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (contex) => LoginView()),
                );
              },
              child: Text('To Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (contex) => RegisterView()),
                );
              },
              child: Text('To Register'),
            ),
          ],
        ),
      ),
    );
  }
}
