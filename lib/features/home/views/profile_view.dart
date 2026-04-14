import 'package:flutter/material.dart';
import 'package:to_do/core/network/api_helper.dart';
import 'package:to_do/core/utils/app_colors.dart';
import 'package:to_do/features/auth/data/model/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserModel? userModel;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${userModel != null ? userModel!.username : ''}'),
      ),
    );
  }

  Future getData() async {
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
