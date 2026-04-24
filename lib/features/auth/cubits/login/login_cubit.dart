// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/features/auth/cubits/login/login_states.dart';
import 'package:to_do/features/auth/data/repo/auth_repo.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  AuthRepo repo = AuthRepo();
  var username = TextEditingController();
  var password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool passwordSecure = true;

  void changePasswordVisibility() {
    passwordSecure = !passwordSecure;
    emit(ChangePasswordVisibility());
  }

  login() async {
    if (formKey.currentState?.validate() == false) return;
    emit(LoginLoadingState());
    var result = await repo.login(
      username: username.text,
      password: password.text,
    );
    result.fold(
      (errorMsg) => emit(LoginErrorState(error: errorMsg)),
      (model) => emit(LoginSuccessState(userModel: model)),
    );
  }
}


 // if (formKey.currentState?.validate() == true) {
    //   setState(() {
    //     isLoading = true;
    //   });
    //   var result = await APIHelper.register(
    //     userName: username.text,
    //     password: password.text,
    //     imagePath: imagePath,
    //   );
    //   result.fold(
    //     (errorMsg) => ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(errorMsg, style: TextStyle(color: AppColors.white)),
    //         backgroundColor: AppColors.error,
    //       ),
    //     ),
    //     (successMsg) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(
    //             successMsg,
    //             style: TextStyle(color: AppColors.white),
    //           ),
    //           backgroundColor: AppColors.primary,
    //         ),
    //       );
    //       Navigator.pop(context);
    //     },
    //   );
    //   setState(() {
    //     isLoading = false;
    //   });
    // }