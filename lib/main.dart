import 'package:flutter/material.dart';
import 'package:login_program/loginScreen.dart';
import 'package:login_program/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ZeroScreen(),
      routes: <String, WidgetBuilder>{
        '/Login_screen': (BuildContext context) => ZeroScreen(),
        '/Home_screen': (BuildContext context) => FirstScreen(),
        '/Share_screen': (BuildContext context) => SecondScreen(),
        '/RegisterScreen': (BuildContext context) => RegisterScreen(),
        '/ForgotPasswordScreen': (BuildContext context) =>
            ForgotPasswordScreen()
      },
    );
  }
}

class SecondScreen extends StatelessWidget {
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
