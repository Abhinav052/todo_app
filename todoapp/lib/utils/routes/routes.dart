import 'package:flutter/material.dart';
import 'package:todolist/views/home_page.dart';
import 'package:todolist/views/login_page.dart';
import 'package:todolist/views/register_page.dart';
import 'package:provider/provider.dart';

class Routes {
  static const String loginScreen = 'login';
  static const String registerScreen = 'register';
  static const String homeScreen = 'home';

  static Route<dynamic> controller(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case Routes.registerScreen:
        return MaterialPageRoute(builder: (context) => RegisterPage());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => HomePage());
      default:
        throw Exception('Route not found: ${settings.name}');
    }
  }
}
