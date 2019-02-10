import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_program/loginScreen.dart';
import 'package:login_program/home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  SharedPreferences sharedPreferences;
  String checkData;

  @override
  void initState() {
    super.initState();
    _onChanged();
  }

  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkData = sharedPreferences.getString("username");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (checkData == null) {
      return LoginScreen();
    } else
      return HomeScreen();
  }
}
