import 'package:flutter/material.dart';

import '../auth/authentication_screen.dart';
import '../home/home_screen.dart';
import '../splash_screen.dart';
import '../auth/verify_phone_number_screen.dart';
import 'helpers.dart';
class RouteGenerator {
  static const _id = 'RouteGenerator';

  static MaterialPageRoute _route(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);

  static Route<dynamic> _errorRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('ROUTE \n\n$name\n\nNOT FOUND'),
        ),
      ),
    );
  }
}
