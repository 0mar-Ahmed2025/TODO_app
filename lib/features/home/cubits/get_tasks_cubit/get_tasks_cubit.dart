// ignore_for_file: strict_top_level_inference

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/features/home/cubits/get_tasks_cubit/get_tasks_states.dart';
import 'package:to_do/features/home/data/models/task_model.dart';
import 'package:to_do/features/home/data/repos/home_repo.dart';

class GetTasksCubit extends Cubit<GetTasksStates> {
  GetTasksCubit() : super(GetTasksInitialState());
  static GetTasksCubit get(context) => BlocProvider.of(context);

  void getTasks() async {
    emit(GetTasksLoadingState());
    HomeRepo repo = HomeRepo();
    var result = await repo.getTasks();
    result.fold(
      (error) => emit(GetTasksErrorState(error: error)),
      (List<TaskModel> tasks) => emit(
        tasks.isEmpty ? EmptyTasksState() : GetTasksSuccessState(tasks: tasks),
      ),
    );
  }
}
