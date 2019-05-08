import 'package:flutter/material.dart';
import 'package:login_program/ui/login.dart';
import 'package:login_program/resources/globals.dart' as globals;
import 'package:login_program/ui/widgets/sign_in_form.dart';
import 'package:login_program/ui/home_screen.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  @override
  Widget build(BuildContext context) {
    if (globals.isLogin == true) {
      return HomeScreen(globals.loginName);
    } else
      return SignInForm();
  }
}
