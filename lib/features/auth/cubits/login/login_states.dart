import 'package:to_do/features/auth/data/models/user_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  UserModel userModel;
  LoginSuccessState({required this.userModel});
}

class LoginErrorState extends LoginStates {
  String error;
  LoginErrorState({required this.error});
}

class ChangePasswordVisibility extends LoginStates {}
