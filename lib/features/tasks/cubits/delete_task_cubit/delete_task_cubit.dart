// ignore_for_file: strict_top_level_inference

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/features/tasks/data/repos/task_repo.dart';

import 'delete_task_state.dart';

class DeleteTaskCubit extends Cubit<DeleteTaskState> {
  DeleteTaskCubit() : super(DeleteTaskInitialState());
  static DeleteTaskCubit get(context) => BlocProvider.of(context);

  void onDeleteTaskPressed(int taskId) async {
    emit(DeleteTaskLoadingState());
    TaskRepo repo = TaskRepo();
    var result = await repo.deleteTask(taskId: taskId);
    result.fold(
      (String error) => emit(DeleteTaskErrorState(error)),
      (u) => emit(DeleteTaskSuccessState()),
    );
  }
}
