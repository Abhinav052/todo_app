import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:todolist/utils/shared_preferance/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../errors/bad_request.dart';
import '../errors/failure.dart';

Future<Either<Failure, T>> get<T>({
  required String url,
  Map<String, String>? headers,
  required T Function(dynamic data) onSuccess,
  bool isAuthorized = true,
}) async {
  try {
    final String accessToken = await TokenStorage.getToken() ?? "";
    headers ??= {};
    if (isAuthorized) {
      headers["Authorization"] = "Bearer $accessToken";
    }
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 400) {
      throw BadRequest(jsonDecode(response.body)["error"]["message"]);
    } else if (response.statusCode != 200) {
      throw Exception("Something went wrong");
    }

    final data = jsonDecode(response.body);
    return right(onSuccess(data));
  } on BadRequest catch (e) {
    return left(Failure(e.message));
  } catch (e) {
    return left(Failure("Something went wrong"));
  }
}

Future<Either<Failure, T>> post<T>({
  required String url,
  required Map<String, dynamic> body,
  Map<String, String>? headers,
  required T Function(dynamic data) onSuccess,
  bool isAuthorized = true,
}) async {
  try {
    final String accessToken = await TokenStorage.getToken() ?? "";
    headers ??= {};
    if (isAuthorized) {
      headers["Authorization"] = "Bearer $accessToken";
    }
    headers["Content-Type"] = "application/json";

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 400) {
      throw BadRequest(jsonDecode(response.body)["error"]["message"]);
    } else if (response.statusCode != 200) {
      throw Exception("Something went wrong");
    }
    final data = jsonDecode(response.body);
    return right(onSuccess(data));
  } on BadRequest catch (e) {
    return left(Failure(e.message));
  } catch (e) {
    return left(Failure("Something went wrong"));
  }
}

Future<Either<Failure, T>> put<T>({
  required String url,
  required Map<String, dynamic> body,
  Map<String, String>? headers,
  required T Function(dynamic data) onSuccess,
  bool isAuthorized = true,
}) async {
  try {
    final String accessToken = await TokenStorage.getToken() ?? "";
    headers ??= {};
    if (isAuthorized) {
      headers["Authorization"] = "Bearer $accessToken";
    }
    headers["Content-Type"] = "application/json";
    final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));

    if (response.statusCode == 400) {
      throw BadRequest(jsonDecode(response.body)["error"]["message"]);
    } else if (response.statusCode != 200) {
      throw Exception("Something went wrong");
    }
    final data = jsonDecode(response.body);
    return right(onSuccess(data));
  } on BadRequest catch (e) {
    return left(Failure(e.message));
  } catch (e) {
    return left(Failure("Something went wrong"));
  }
}
