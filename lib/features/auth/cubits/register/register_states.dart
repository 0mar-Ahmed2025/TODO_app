abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  String message;
  RegisterSuccessState(this.message);
}

class RegisterErrorState extends RegisterStates {
  String error;
  RegisterErrorState(this.error);
}

class ChangePasswordVisibility extends RegisterStates {}

class ChangeConfirmPasswordVisibility extends RegisterStates {}
