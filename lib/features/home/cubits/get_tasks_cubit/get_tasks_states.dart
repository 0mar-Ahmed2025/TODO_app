import 'package:to_do/features/home/data/models/task_model.dart';

abstract class GetTasksStates {}

class GetTasksInitialState extends GetTasksStates {}

class GetTasksLoadingState extends GetTasksStates {}

class EmptyTasksState extends GetTasksStates {}

class GetTasksSuccessState extends GetTasksStates {
  List<TaskModel> tasks;
  GetTasksSuccessState({required this.tasks});
}

class GetTasksErrorState extends GetTasksStates {
  String error;
  GetTasksErrorState({required this.error});
}
