import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:to_do/core/cache/cache_helper.dart';
import 'package:to_do/core/cache/cache_keys.dart';
import 'package:to_do/core/network/api_helper.dart';
import 'package:to_do/core/network/api_response.dart';
import 'package:to_do/core/network/end_points.dart';
import 'package:to_do/features/auth/data/models/login_response_model.dart';
import 'package:to_do/features/auth/data/models/user_model.dart';

class AuthRepo {
  APIHelper apiHelper = APIHelper();

  Future<Either<String, UserModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      var loginResponse = await apiHelper.postRequest(
        endPoint: EndPoints.login,
        data: {'username': username, 'password': password},
      );

      if (loginResponse.status) {
        // serialization
        var loginResponseModel = LoginResponseModel.fromJson(
          loginResponse.data as Map<String, dynamic>,
        );

        // save tokens
        await CacheHelper.setValue(
          CacheKeys.accessToken,
          loginResponseModel.accessToken!,
        );
        await CacheHelper.setValue(
          CacheKeys.refreshToken,
          loginResponseModel.refreshToken!,
        );

        return Right(loginResponseModel.userModel!);
      } else {
        return left(loginResponse.message);
      }
    } catch (e) {
      return left(ApiResponse.fromError(e).message);
    }
  }

  Future<Either<String, String>> register({
    required String username,
    required String password,
    String? imagePath,
  }) async {
    try {
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.register,
        data: {
          'username': username,
          'password': password,
          if (imagePath != null)
            'image': await MultipartFile.fromFile(imagePath),
        },
      );

      if (response.status) {
        // serialization
        return right(response.message);
      } else {
        return left(response.message);
      }
    } catch (e) {
      return left(ApiResponse.fromError(e).message);
    }
  }
}
