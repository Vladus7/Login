import 'package:flutter/material.dart';
import 'package:login_program/loginScreen.dart';
import 'package:login_program/home_screen.dart';
import 'package:login_program/account_screen.dart';
import 'package:login_program/about_us_screens.dart';
import 'package:login_program/all_screen.dart';
import 'package:login_program/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: <String, WidgetBuilder>{
        '/login_screen': (BuildContext context) => LoginScreen(),
        '/home_screen': (BuildContext context) => HomeScreen(),
        '/share_screen': (BuildContext context) => ShareScreen(),
        '/account_screen': (BuildContext context) => AccountScreen(),
        '/register_screen': (BuildContext context) => RegisterScreen(),
        '/forgot_password_screen': (BuildContext context) =>
            ForgotPasswordScreen(),
        '/us_screen': (BuildContext context) => UsScreen(),
        '/map_screen': (BuildContext context) => MapScreen(),
      },
    );
  }
}
