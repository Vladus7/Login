import 'package:flutter/material.dart';
import 'package:login_program/loginScreen.dart';
import 'package:login_program/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  ZeroScreen(),
      routes: <String, WidgetBuilder>{
        '/screen1': (BuildContext context) => ZeroScreen(),
        '/screen2': (BuildContext context) => FirstScreen(),
        '/screen3': (BuildContext context) => SecondScreen(),
        '/screen4': (BuildContext context) => RegisterScteen(),
        '/screen5': (BuildContext context) => ForgotPasswordScteen()
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

class RegisterScteen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Register")), body: Text('Go back!'));
  }
}

class ForgotPasswordScteen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Forgot password")), body: Text('Go back!'));
  }
}
