import 'package:flutter/material.dart';
import 'package:login_program/loginScreen.dart';
import 'package:login_program/home_screen.dart';
import 'package:login_program/account_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/login_screen': (BuildContext context) => LoginScreen(),
        '/home_screen': (BuildContext context) => HomeScreen(),
        '/share_screen': (BuildContext context) => ShareScreen(),
        '/account_screen':(BuildContext context) => AccountScreen(),
        '/register_screen': (BuildContext context) => RegisterScreen(),
        '/forgot_password_screen': (BuildContext context) =>
            ForgotPasswordScreen()
      },
    );
  }
}

class ShareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Screen"),
        ),
        body: Text('Go back!'));
  }
}

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Register")), body: Text('Go back!'));
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Forgot password")), body: Text('Go back!'));
  }
}
