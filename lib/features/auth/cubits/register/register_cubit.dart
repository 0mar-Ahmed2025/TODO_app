// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/features/auth/cubits/register/register_states.dart';
import 'package:to_do/features/auth/data/repo/auth_repo.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);

  AuthRepo repo = AuthRepo();
  var username = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? imagePath;

  bool passwordSecure = true;
  bool confirmPasswordSecure = true;
  bool isLoading = false;

  void changePasswordVisibility() {
    passwordSecure = !passwordSecure;
    emit(ChangePasswordVisibility());
  }

  void changeConfirmPasswordVisibility() {
    confirmPasswordSecure = !confirmPasswordSecure;
    emit(ChangeConfirmPasswordVisibility());
  }

  register() async {
    if (formKey.currentState?.validate() == false) return;
    emit(RegisterLoadingState());
    var result = await repo.register(
      username: username.text,
      password: password.text,
      imagePath: imagePath,
    );
    result.fold(
      (errorMsg) => emit(RegisterErrorState(errorMsg)),
      (successMsg) => emit(RegisterSuccessState(successMsg)),
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