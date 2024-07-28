import 'package:flutter/material.dart';
import 'package:todolist/services/auth_service.dart';
import 'package:todolist/services/user.service.dart';
import 'package:todolist/utils/routes/routes.dart';
import 'package:todolist/utils/shared_preferance/token_storage.dart';

class AuthViewModel extends ChangeNotifier {
  bool isAuthenticated = false;
  Map<String, dynamic> user = {};

  Future<void> login(Map<String, dynamic> userData) async {
    if (await TokenStorage.tokenExists()) {
      user = userData;
      isAuthenticated = true;
      notifyListeners();
    }
  }

  bool get getAuthenticationStatus => isAuthenticated;

  Future<void> logout() async {
    await TokenStorage.removeToken();
    user = {};
    isAuthenticated = false;
    notifyListeners();
  }

  Future<void> updateUserDetails(BuildContext context) async {
    final response = await UserService.getUser();
    response.fold((l) {
      logout();
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false);
    }, (r) {
      login(r);
    });
  }
}
