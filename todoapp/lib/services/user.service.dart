import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/utils/shared_preferance/token_storage.dart';
import '../utils/errors/bad_request.dart';
import '../utils/errors/failure.dart';

class UserService {
  static Future<Either<Failure, Map<String, dynamic>>> getUser() async {
    try {
      Map<String, String> headers = <String, String>{};
      String token = await TokenStorage.getToken() ?? "";
      headers["Authorization"] = "Bearer $token";
      final response = await http.get(
        Uri.parse("${dotenv.env['API_BASE_URL']}/api/users/me"),
        headers: headers,
      );
      if (response.statusCode == 400) {
        throw BadRequest(jsonDecode(response.body)["error"]["message"]);
      } else if (response.statusCode != 200) {
        throw Exception("Something went wrong");
      }
      final data = jsonDecode(response.body);
      return right(data);
    } on BadRequest catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure("Something went wrong"));
    }
  }
}
