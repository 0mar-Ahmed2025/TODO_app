// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do/features/home/data/models/task_model.dart';
import 'package:to_do/features/tasks/cubits/update_task_cubit/update_task_state.dart';
import 'package:to_do/features/tasks/data/repos/task_repo.dart';

class UpdateTaskCubit extends Cubit<UpdateTaskState> {
  UpdateTaskCubit(this.taskModel) : super(UpdateTaskInitialState()) {
    title.text = taskModel.title ?? '';
    description.text = taskModel.description ?? '';
  }
  static UpdateTaskCubit get(context) => BlocProvider.of(context);
  final TaskModel taskModel;

  XFile? image;
  void pickImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    emit(UpdateTaskImageChangedState());
  }

  var title = TextEditingController();
  var description = TextEditingController();
  var formKey = GlobalKey<FormState>();

  void onUpdateTaskPressed() async {
    if (formKey.currentState?.validate() == true) {
      emit(UpdateTaskLoadingState());
      TaskRepo repo = TaskRepo();
      var result = await repo.updateTask(
        taskId: taskModel.id!,
        title: title.text,
        description: description.text,
        image: image,
      );
      result.fold(
        (String error) => emit(UpdateTaskErrorState(error)),
        (u) => emit(UpdateTaskSuccessState()),
      );
    }
  }
}
