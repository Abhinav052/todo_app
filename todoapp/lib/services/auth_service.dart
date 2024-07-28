import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/utils/service/http_service.dart';
import 'package:todolist/utils/shared_preferance/token_storage.dart';
import '../utils/errors/bad_request.dart';
import '../utils/errors/failure.dart';

class AuthService {
  static Future<Either<Failure, Map<String, dynamic>>> register(
      {required String userName, required String email, required String password}) async {
    return await post<Map<String, dynamic>>(
        url: "${dotenv.env['API_BASE_URL']}/api/auth/local/register",
        body: {"username": userName, "email": email, "password": password},
        isAuthorized: false,
        onSuccess: (data) {
          TokenStorage.saveToken(data["jwt"]);
          return data["user"];
        });
  }

  static Future<Either<Failure, Map<String, dynamic>>> login(
      {required String identifier, required String password}) async {
    return await post<Map<String, dynamic>>(
        url: "${dotenv.env['API_BASE_URL']}/api/auth/local/",
        body: {"identifier": identifier, "password": password},
        isAuthorized: false,
        onSuccess: (data) {
          TokenStorage.saveToken(data["jwt"]);
          return data["user"];
        });
  }
}

//
// Future<Either<Failure, Map<String, dynamic>>> register(
//     {required String userName, required String email, required String password
//       // required Map<String, dynamic> Function(dynamic data) onSuccess,
//     }) async {
//   try {
//     Map<String, String> headers = <String, String>{};
//     headers["Content-Type"] = "application/json";
//
//     final response = await http.post(
//         Uri.parse("${dotenv.env['API_BASE_URL']}/api/auth/local/register"),
//         headers: headers,
//         body: jsonEncode({"username": userName, "email": email, "password": password}));
//     if (response.statusCode == 400) {
//       throw BadRequest(jsonDecode(response.body)["error"]["message"]);
//     } else if (response.statusCode != 200) {
//       throw Exception("Something went wrong");
//     }
//     final data = jsonDecode(response.body);
//     await TokenStorage.saveToken(data["jwt"]);
//     return right(data["user"]);
//     // return right(onSuccess(data));
//   } on BadRequest catch (e) {
//     return left(Failure(e.message));
//   } catch (e) {
//     return left(Failure("Something went wrong"));
//   }
// }
//
// Future<Either<Failure, Map<String, dynamic>>> login(
//     {required String identifier, required String password
//       // required Map<String, dynamic> Function(dynamic data) onSuccess,
//     }) async {
//   try {
//     Map<String, String> headers = <String, String>{};
//     headers["Content-Type"] = "application/json";
//
//     final response = await http.post(Uri.parse("${dotenv.env['API_BASE_URL']}/api/auth/local/"),
//         headers: headers, body: jsonEncode({"identifier": identifier, "password": password}));
//     if (response.statusCode == 400) {
//       throw BadRequest(jsonDecode(response.body)["error"]["message"]);
//     } else if (response.statusCode != 200) {
//       throw Exception("Something went wrong");
//     }
//     final data = jsonDecode(response.body);
//     return right(data);
//     // return right(onSuccess(data));
//   } on BadRequest catch (e) {
//     return left(Failure(e.message));
//   } catch (e) {
//     return left(Failure("Something went wrong"));
//   }
// }
