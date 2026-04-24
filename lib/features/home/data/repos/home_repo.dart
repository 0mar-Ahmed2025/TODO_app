// ignore_for_file: empty_catches
import 'package:dartz/dartz.dart';
import 'package:to_do/core/network/api_helper.dart';
import 'package:to_do/core/network/api_response.dart';
import 'package:to_do/core/network/end_points.dart';
import 'package:to_do/features/auth/data/models/user_model.dart';
import 'package:to_do/features/home/data/models/task_model.dart';
import 'package:to_do/features/home/data/models/task_response_model.dart';

class HomeRepo {
  APIHelper apiHelper = APIHelper();

  Future<Either<String, List<TaskModel>>> getTasks() async {
    try {
      var response = await apiHelper.getRequest(
        isProtected: true,
        endPoint: EndPoints.getTasks,
      );
      var getTasksModel = GetTasksReponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      if (response.status) {
        return right(getTasksModel.tasks ?? []);
      } else {
        return left(response.message);
      }
    } catch (e) {
      return left(ApiResponse.fromError(e).message);
    }
  }
}
