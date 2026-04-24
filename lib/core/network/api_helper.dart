// ignore_for_file: avoid_print, empty_catches, prefer_typing_uninitialized_variables
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/core/cache/cache_helper.dart';
import 'package:to_do/core/cache/cache_keys.dart';
import 'package:to_do/core/network/api_response.dart';
import 'package:to_do/core/network/end_points.dart';

class APIHelper {
  // declaring dio
  static final Dio _dio = Dio(BaseOptions(baseUrl: EndPoints.baseURL));
  static Future init() async {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("--- Headers : ${options.headers.toString()}");
          print("--- endpoint : ${options.path.toString()}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("--- Response : ${response.data.toString()}");
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          print("--- Error : ${error.response?.data.toString()}");
          var errorResponse = error.response?.data as Map<String, dynamic>;
          try {
            if (errorResponse['message'].toString().contains(
              'Token has expired.',
            )) {
              var result = await _dio.post(
                EndPoints.refreshToken,
                options: Options(
                  headers: {
                    'Authorization':
                        'Bearer ${await CacheHelper.getValue(CacheKeys.refreshToken)}',
                  },
                ),
              );
              var accessData = result.data as Map<String, dynamic>;
              await CacheHelper.setValue(
                CacheKeys.accessToken,
                accessData['access_token'],
              );

              // Retry original request
              final options = error.requestOptions;
              if (options.data is FormData) {
                final oldFormData = options.data as FormData;

                // Convert FormData to map so it can be rebuilt
                final Map<String, dynamic> formMap = {};
                for (var entry in oldFormData.fields) {
                  formMap[entry.key] = entry.value;
                }

                // Add files if any
                for (var file in oldFormData.files) {
                  formMap[file.key] = file.value;
                }

                // Rebuild new FormData
                options.data = FormData.fromMap(formMap);
              }
              options.headers['Authorization'] =
                  'Bearer ${CacheHelper.getValue(CacheKeys.accessToken) ?? ''}';
              final response = await _dio.fetch(options);
              return handler.resolve(response);
            }
          } catch (e) {}

          return handler.next(error);
        },
      ),
    );
  }

  Future<ApiResponse> getRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = true,
    bool isProtected = false,
    bool sendRefreshToken = false,
  }) async {
    var token;
    if (isProtected) {
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref.getString(
        sendRefreshToken ? 'refresh_token' : 'access_token',
      );
    }
    return ApiResponse.fromResponse(
      await _dio.get(
        endPoint,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(
          headers: {if (isProtected) 'Authorization': 'Bearer $token'},
        ),
      ),
    );
  }

  // post
  Future<ApiResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isProtected = false,
    bool sendRefreshToken = false,
  }) async {
    var token;
    if (isProtected) {
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref.getString(
        sendRefreshToken ? 'refresh_token' : 'access_token',
      );
    }
    return ApiResponse.fromResponse(
      await _dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(
          headers: {if (isProtected) 'Authorization': 'Bearer $token'},
        ),
      ),
    );
  }

  Future<ApiResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = true,
    bool isProtected = false,
    bool sendRefreshToken = false,
  }) async {
    var token;
    if (isProtected) {
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref.getString(
        sendRefreshToken ? 'refresh_token' : 'access_token',
      );
    }
    return ApiResponse.fromResponse(
      await _dio.put(
        endPoint,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(
          headers: {if (isProtected) 'Authorization': 'Bearer $token'},
        ),
      ),
    );
  }

  Future<ApiResponse> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = true,
    bool isProtected = false,
    bool sendRefreshToken = false,
  }) async {
    var token;
    if (isProtected) {
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref.getString(
        sendRefreshToken ? 'refresh_token' : 'access_token',
      );
    }
    return ApiResponse.fromResponse(
      await _dio.delete(
        endPoint,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(
          headers: {if (isProtected) 'Authorization': 'Bearer $token'},
        ),
      ),
    );
  }
}


// abstract class APIHelper{
//   static final _dio = Dio(BaseOptions(
//     baseUrl: EndPoints.baseURL
//   ));
//   static Future init() async {
//     _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
//       print("--- Headers : ${options.headers.toString()}");
//       print("--- endpoint : ${options.path.toString()}");
//       return handler.next(options);
//     }, onResponse: (response, handler) {
//       print("--- Response : ${response.data.toString()}");
//       return handler.next(response);
//     }, onError: (DioException error, handler) async {
//       print("--- Error : ${error.response?.data.toString()}");
//       var errorResponse = error.response?.data as Map<String, dynamic>;
//       try{
//         if (errorResponse['message']
//             .toString()
//             .contains('Token has expired.')) {
//           var result = await _dio.post(EndPoints.refreshToken,
//               options: Options(headers: {
//                 'Authorization':
//                     'Bearer ${await CacheHelper.getValue(CacheKeys.refreshToken)}'
//               }));
//           var accessData = result.data as Map<String, dynamic>;
//           await CacheHelper.setValue(
//               CacheKeys.accessToken, accessData['access_token']);
//
//           // Retry original request
//           final options = error.requestOptions;
//           if (options.data is FormData) {
//             final oldFormData = options.data as FormData;
//
//             // Convert FormData to map so it can be rebuilt
//             final Map<String, dynamic> formMap = {};
//             for (var entry in oldFormData.fields) {
//               formMap[entry.key] = entry.value;
//             }
//
//             // Add files if any
//             for (var file in oldFormData.files) {
//               formMap[file.key] = file.value;
//             }
//
//             // Rebuild new FormData
//             options.data = FormData.fromMap(formMap);
//           }
//           options.headers['Authorization'] =
//               'Bearer ${CacheHelper.getValue(CacheKeys.accessToken) ?? ''}';
//           final response = await _dio.fetch(options);
//           return handler.resolve(response);
//         }
//       }
//       catch(e){
//
//       }
//
//       return handler.next(error);
//     }));
//   }
//
//   static Future<Either<String, String>> addTask({
//     required String title,
//     required String description,
//     String? imagePath
// }) async{
//     try {
//       var response = await _dio.post(
//           EndPoints.newTask,
//           data: FormData.fromMap({
//             'title': title,
//             'description': description,
//             if(imagePath != null) 'image': await MultipartFile.fromFile(imagePath)
//           }),
//           options: Options(
//               headers: {
//                 'Authorization': 'Bearer ${CacheHelper.getValue(
//                     CacheKeys.accessToken)}'
//               }
//           )
//       );
//       var data = response.data as Map<String, dynamic>;
//       return right(data['message'] ?? 'Task added successfully');
//     }
//     catch(e){
//       if(e is DioException){
//         var data = e.response?.data as Map<String, dynamic>;
//         return left(data['message'] ?? 'Something went wrong');
//       }
//       else{
//         return left('Something went wrong');
//       }
//     }
//   }
//
//   static Future<Either<String, String>> updateTask({
//     required int id,
//     required String title,
//     required String description,
//     String? imagePath
// }) async{
//     try {
//       var response = await _dio.put(
//           '${EndPoints.updateTask}/$id',
//           data: FormData.fromMap({
//             'title': title,
//             'description': description,
//             if(imagePath != null) 'image': await MultipartFile.fromFile(imagePath)
//           }),
//           options: Options(
//               headers: {
//                 'Authorization': 'Bearer ${CacheHelper.getValue(
//                     CacheKeys.accessToken)}'
//               }
//           )
//       );
//       var data = response.data as Map<String, dynamic>;
//       return right(data['message'] ?? 'Task updated successfully');
//     }
//     catch(e){
//       if(e is DioException){
//         var data = e.response?.data as Map<String, dynamic>;
//         return left(data['message'] ?? 'Something went wrong');
//       }
//       else{
//         return left('Something went wrong');
//       }
//     }
//   }
//
//
//
//
//
//
//
//
//   static Future<Either<String, UserModel>> getUserData() async {
//     try {
//       var userDataResponse = await _dio.get(EndPoints.getUserData,
//           options: Options(headers: {
//             'Authorization':
//             'Bearer ${await CacheHelper.getValue(CacheKeys.accessToken)}'
//           }));
//       var data = userDataResponse.data as Map<String, dynamic>;
//       UserModel userModel = UserModel.fromJson(data['user']);
//       return Right(userModel);
//     } catch (e) {
//       if (e is DioException) {
//         var errorResponse = e.response?.data as Map<String, dynamic>;
//         return Left(errorResponse['message'] ?? 'Unknown error');
//       } else {
//         return Left('An Error occurred.\nTry again later');
//       }
//     }
//   }
//
//   static Future<Either<String, UserModel>> login(
//       {required String username, required String password}) async {
//     try {
//       var loginResponse = await _dio.post(EndPoints.login,
//           data: FormData.fromMap({'username': username, 'password': password}));
//       // serialization
//       var loginResponseModel = LoginResponseModel.fromJson(
//           loginResponse.data as Map<String, dynamic>);
//
//       // save tokens
//       await CacheHelper.setValue(
//           CacheKeys.accessToken, loginResponseModel.accessToken!);
//       await CacheHelper.setValue(
//           CacheKeys.refreshToken, loginResponseModel.refreshToken!);
//
//       return Right(loginResponseModel.userModel!);
//     } catch (e) {
//       if (e is DioException) {
//         var errorResponse = e.response?.data as Map<String, dynamic>;
//         return Left(errorResponse['message'] ?? 'Unknown error');
//       } else {
//         return Left('An Error occurred.\nTry again later');
//       }
//     }
//   }
//
//   static Future<Either<String, List<TaskModel>>> getTasks() async {
//     try {
//       var registerResponse = await _dio.get('my_tasks',
//           options: Options(headers: {
//             'Authorization':
//             'Bearer ${await CacheHelper.getValue(CacheKeys.accessToken)}'
//           }));
//       var tasksResponse = registerResponse.data as Map<String, dynamic>;
//       List<TaskModel> tasks = [];
//       for (var taskJson in tasksResponse['tasks']) {
//         tasks.add(TaskModel.fromJson(taskJson));
//       }
//       return Right(tasks);
//     } catch (e) {
//       if (e is DioException) {
//         var errorResponse = e.response?.data as Map<String, dynamic>;
//         return Left(errorResponse['message'] ?? 'Unknown error');
//       } else {
//         print(e.toString());
//         return Left('An Error occurred.\nTry again later');
//       }
//     }
//   }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// }
//
// abstract class NewsAPIHelper{
//   static final dio = Dio(BaseOptions(
//       baseUrl: 'https://newsapi.org/v2/'
//   ));
//
//
//   }
//
//