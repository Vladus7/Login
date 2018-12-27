import 'package:flutter/material.dart';
import 'package:login_program/loginScreen.dart';
import 'package:login_program/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login_screen(),
      routes: <String, WidgetBuilder>{
        '/login_screen': (BuildContext context) => Login_screen(),
        '/home_screen': (BuildContext context) => Home_screen(),
        '/share_screen': (BuildContext context) => Share_screen(),
        '/registerScreen': (BuildContext context) => RegisterScreen(),
        '/forgotPasswordScreen': (BuildContext context) =>
            ForgotPasswordScreen()
      },
    );
  }
}

class Share_screen extends StatelessWidget {
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
